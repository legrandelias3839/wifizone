# server.py
from flask import Flask, request, redirect, render_template_string
import json
import random
import threading
import time
import urllib.parse
from routeros_api import RouterOsApiPool
from pathlib import Path
from datetime import datetime

BASE = Path(__file__).parent          # <-- ajoute ça

# --- CONFIGURATION ---
HOST = "0.0.0.0"
PORT = 5656
MIKROTIK_IP = "10.10.10.1"
MIKROTIK_USER = "display"
MIKROTIK_PWD = "21330201"

# dictionnaires en mémoire
tx_vouchers = {}
tx_status = {}
error_cache = {}

# Mapping des profils
TICKET_PAGES = {
    'CODENORMAL': 'ticketnormal.html',
    'CODEPRENIUM': 'ticketprenium.html',
    'CODEVIP': 'ticketvip.html',
    'CODEFLASH': 'ticketflash.html',
    'CODEILLIMITE': 'ticketillimite.html'
}
VOUCHER_PREFIXES = {
    'CODENORMAL': 'NOR',
    'CODEPRENIUM': 'PRE',
    'CODEVIP': 'VIP',
    'CODEFLASH': 'FLASH',
    'CODEILLIMITE': 'BOSS'
}

# Application Flask
app = Flask(__name__)

# ---------- ROUTES ----------

@app.route('/voucher/<tx_id>', methods=['GET'])
def voucher_get(tx_id):
    profile = request.args.get('profile', 'CODENORMAL')

    # Transaction annulée récemment ?
    if tx_id in error_cache and (time.time() - error_cache[tx_id]) < 30:
        return render_template_string("""
            <html>
            <head><title>Paiement annulé</title></head>
            <body style="font-family: Arial; text-align: center; padding: 50px;">
            <h2>❌ Paiement annulé ou expiré</h2>
            <p>Cette transaction a été annulée ou est expirée.</p>
            <button onclick="window.location.href='http://display.bj'" 
                    style="padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer;">
            Retour au portail
            </button>
            </body>
            </html>
        """), 200

    max_wait = 10
    waited = 0
    while waited < max_wait:
        creds = tx_vouchers.pop(tx_id, None)
        if creds:
            user, pwd, profile = creds
            tx_status.pop(tx_id, None)
            error_cache.pop(tx_id, None)
            ticket_page = TICKET_PAGES.get(profile, 'ticketnormal.html')
            return redirect(f'/{ticket_page}?user={user}&pass={pwd}')

        if tx_status.get(tx_id) == 'error':
            error_cache[tx_id] = time.time()
            tx_status.pop(tx_id, None)
            return render_template_string("""
                <html>
                <head><title>Paiement échoué</title></head>
                <body style="font-family: Arial; text-align: center; padding: 50px;">
                <h2>❌ Paiement échoué ou annulé</h2>
                <p>Aucun voucher n'a été généré. Veuillez réessayer votre achat.</p>
                <button onclick="window.location.href='http://display.bj'" 
                        style="padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer;">
                Retour au portail
                </button>
                </body>
                </html>
            """), 200

        time.sleep(0.5)
        waited += 0.5

    # Toujours en attente
    return render_template_string("""
        <html>
        <head>
            <meta charset="utf-8">
            <title>Traitement en cours...</title>
            <meta http-equiv="refresh" content="2;url={{ request.url }}">
            <style>
                body{font-family:Arial;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;background:#f5f5f5}
                .container{text-align:center;padding:40px;background:white;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,.1)}
                .spinner{border:4px solid #f3f3f3;border-top:4px solid #3498db;border-radius:50%;width:50px;height:50px;animation:spin 1s linear infinite;margin:0 auto 20px}
                @keyframes spin{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="spinner"></div>
                <h2>⏳ Traitement en cours...</h2>
                <p>Votre paiement est en cours de validation.</p>
                <small>Redirection automatique dans 2 secondes</small>
            </div>
        </body>
        </html>
    """)

@app.route('/<ticket_page>')
def ticket_page(ticket_page):
    if ticket_page not in TICKET_PAGES.values():
        return "Page non trouvée", 404
    fichier = BASE / ticket_page
    if not fichier.exists():
        return f"{ticket_page} introuvable", 404
    html = fichier.read_text(encoding='utf-8')
    return html.replace('{{ user }}', request.args.get('user', '')) \
               .replace('{{ pass }}', request.args.get('pass', ''))

@app.route('/webhook', methods=['POST'])
def webhook():
    try:
        payload = request.get_json(force=True)
    except Exception as e:
        return f"Erreur JSON: {e}", 400

    event   = payload.get("name")
    obj     = payload.get("entity", {})
    tx_id   = str(obj.get("id"))
    status  = obj.get("status")

    print(f"📥 Webhook reçu: {event}/{status} tx_id={tx_id}")

    if event == "transaction.approved" and status == "approved" and tx_id:
        tx_status[tx_id] = 'pending'

        # --- INFOS COMPLÉMENTAIRES ---
        phone      = obj.get("customer", {}).get("phone", "N/A")
        pay_method = obj.get("payment_method", "N/A")
        created_at = obj.get("created_at", "N/A")          # format ISO 8601
        try:
            created_at = datetime.fromisoformat(created_at.replace("Z", "+00:00")).strftime("%d/%m/%Y %H:%M:%S")
        except Exception:
            created_at = "date invalide"

        description = obj.get("description", "")
        profile = "CODENORMAL"
        if "PREMIUM" in description:
            profile = "CODEPRENIUM"
        elif "VIP" in description:
            profile = "CODEVIP"
        elif "FLASH" in description:
            profile = "CODEFLASH"
        elif "ILLIMITE" in description:
            profile = "CODEILLIMITE"

        prefix = VOUCHER_PREFIXES.get(profile, 'NOR')
        user = f"{prefix}{random.randint(1000, 9999)}"
        pwd  = str(random.randint(1000, 9999))

        tx_vouchers[tx_id] = (user, pwd, profile)
        tx_status[tx_id]   = 'approved'

        # --- AFFICHAGE CONSOLE ---
        print(f"✅ Transaction {tx_id} APPROUVÉE")
        print(f"   📱 Téléphone    : {phone}")
        print(f"   💳 Mode paiement: {pay_method}")
        print(f"   📅 Date/heure   : {created_at}")
        print(f"   🎫 Voucher créé : {user}/{pwd}  profil={profile}")

        threading.Thread(target=create_hotspot_user, args=(user, pwd, profile), daemon=True).start()

    elif event == "transaction.canceled" or status == "canceled":
        tx_status[tx_id] = 'error'
        error_cache[tx_id] = time.time()
        print(f"❌ Transaction {tx_id} annulée")

    return "OK", 200

def create_hotspot_user(username, password, profile="CODENORMAL"):
    try:
        api = RouterOsApiPool(
            MIKROTIK_IP,
            username=MIKROTIK_USER,
            password=MIKROTIK_PWD,
            plaintext_login=True,
            use_ssl=False
        ).get_api()
        api.get_resource('/ip/hotspot/user').add(
            name=username,
            password=password,
            profile=profile,
            server="hotspot1"
        )
        print(f"📶 Utilisateur hotspot créé: {username}/{password} avec profil {profile}")
    except Exception as e:
        print(f"❌ Erreur création user MikroTik: {e}")