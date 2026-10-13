"""
Nur Pusulasi - Admin Content Server
Yerel HTTP sunucu: admin paneli ve Flutter uygulamasi arasinda kopru.

Calistirma:
    python admin/server.py

Endpointler:
    GET  /                    -> admin panelini acar
    GET  /content/<file>.json -> icerik dosyasini verir (Flutter icin)
    POST /save/<file>.json    -> admin panelden gelen JSON'u kaydeder
"""
import json
import os
import urllib.parse
from http.server import HTTPServer, SimpleHTTPRequestHandler

ROOT = os.path.dirname(os.path.abspath(__file__))
PROJECT = os.path.dirname(ROOT)
CONTENT_DIR = os.path.join(PROJECT, 'assets', 'content')


class Handler(SimpleHTTPRequestHandler):
    def _cors(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')

    def do_OPTIONS(self):
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path.startswith('/content/'):
            fname = parsed.path.replace('/content/', '').strip('/')
            filepath = os.path.join(CONTENT_DIR, fname)
            if os.path.exists(filepath):
                with open(filepath, 'rb') as f:
                    data = f.read()
                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self._cors()
                self.send_header('Content-Length', str(len(data)))
                self.end_headers()
                self.wfile.write(data)
                return
            self.send_response(404)
            self._cors()
            self.end_headers()
            self.wfile.write(b'{"error":"not found"}')
            return
        # Statik dosyalar (admin/index.html vs.)
        super().do_GET()

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path.startswith('/save/'):
            fname = parsed.path.replace('/save/', '').strip('/')
            # Guvenlik: sadece .json
            if not fname.endswith('.json') or '/' in fname or '\\' in fname:
                self.send_response(400)
                self._cors()
                self.end_headers()
                self.wfile.write(b'{"error":"invalid filename"}')
                return
            length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(length)
            try:
                json.loads(body.decode('utf-8'))
            except Exception as e:
                self.send_response(400)
                self._cors()
                self.end_headers()
                self.wfile.write(json.dumps({'error': str(e)}).encode())
                return
            os.makedirs(CONTENT_DIR, exist_ok=True)
            filepath = os.path.join(CONTENT_DIR, fname)
            with open(filepath, 'wb') as f:
                f.write(body)
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self._cors()
            self.end_headers()
            self.wfile.write(b'{"status":"ok"}')
            return
        self.send_response(404)
        self.end_headers()

    def log_message(self, fmt, *args):
        print('[SERVER]', fmt % args)


if __name__ == '__main__':
    os.chdir(ROOT)
    port = 8080
    print(f'Admin paneli:  http://localhost:{port}/index.html')
    print(f'Icerik icin:   http://localhost:{port}/content/ayetler.json')
    print(f'Kaydetmek icin: POST http://localhost:{port}/save/ayetler.json')
    print('Durdurmak icin: Ctrl+C')
    HTTPServer(('0.0.0.0', port), Handler).serve_forever()