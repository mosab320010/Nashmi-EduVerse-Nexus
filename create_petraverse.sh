#!/bin/bash
# ======================================================================================
# PetraVerse - Final Build & Deployment Script
#
# أمر التنفيذ:
# 1. احفظ هذا الملف باسم `create_petraverse.sh`.
# 2. امنحه صلاحيات التنفيذ: `chmod +x create_petraverse.sh`
# 3. قم بتشغيل السكربت: `./create_petraverse.sh`
#
# سيقوم هذا السكربت بإنشاء الهيكلية الكاملة لمشروع PetraVerse مع جميع الملفات المصدرية.
# ======================================================================================

echo "🚀 بدء تنفيذ بناء مشروع PetraVerse الكامل..."

# ======================================================================================
# 1. إنشاء الهيكلية الأساسية للمجلدات
# ======================================================================================
echo "-> إنشاء هيكلية المجلدات..."
mkdir -p PetraVerse/{.github/workflows,backend/{contracts/abi,routes,services,utils,tests,migrations},frontend/{public/{models,audio},src/{components,services,styles}},infrastructure/{backup,k8s,prometheus}}
echo "✅ تم إنشاء هيكلية المجلدات بنجاح."

# ======================================================================================
# 2. إنشاء ملفات المشروع (ملف تلو الآخر)
# ======================================================================================

# --- ملفات الجذر ---
echo "-> إنشاء ملفات الجذر (.gitignore, README.md, .env.example)..."

cat <<'EOF' > PetraVerse/.gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg
*.sqlite
/instance

# Node.js
node_modules/
npm-debug.*
yarn-debug.*
yarn-error.*
yarn-rc.*
.pnpm-debug.*
lerna-debug.*
.pnpm-store
dist
dist-ssr
*.local
build/

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.env.*

# Docker
docker-compose.override.yml

# System files
.DS_Store
Thumbs.db
EOF

cat <<'EOF' > PetraVerse/README.md
# PetraVerse - منصة التعلم الثقافي المعزز

PetraVerse هي منصة تعليمية مبتكرة تدمج الذكاء الاصطناعي، البلوكشين، والواقع الممتد (XR) لتقديم تجربة ثقافية وتعليمية غامرة تتمحور حول التراث الأردني والعالمي.

## نظرة عامة

يهدف المشروع إلى توفير نظام بيئي متكامل يشمل:
- **نظام إدارة تعلم (LMS):** لإدارة المناهج، الفصول الدراسية، والواجبات.
- **تجارب XR تفاعلية:** للسفر عبر الزمن واستكشاف المواقع التاريخية.
- **مساعد ذكاء اصطناعي شخصي:** "زينب"، المرشدة الرقمية التي تتفاعل مع المستخدمين.
- **اقتصاد رمزي:** قائم على عملة `$PETRA` ونظام سمعة على البلوكشين.
- **أرشيف معرفي حي:** يربط بين المحتوى الذي ينشئه المستخدمون والمحتوى التعليمي.

## الإعداد والتشغيل باستخدام Docker

### المتطلبات الأساسية
- Docker و Docker Compose مثبتان على جهازك.

### خطوات الإعداد
1. **استنساخ المشروع**:
   ```bash
   # تم إنشاء المشروع عبر السكربت. انتقل إلى المجلد.
   cd PetraVerse

 * إعداد المتغيرات البيئية:
   * قم بنسخ .env.example إلى .env واملأ المتغيرات المطلوبة (مفاتيح API، كلمات المرور، إلخ).
 * تشغيل الخدمات باستخدام Docker Compose:
   docker-compose up --build -d

 * تشغيل ترحيل قاعدة البيانات (Database Migrations):
   docker-compose exec backend flask db upgrade

 * الوصول إلى التطبيق:
   * Frontend: http://localhost:3000
   * Backend API: http://localhost:5000/api
   * Swagger API Docs: http://localhost:5000/apidocs
   * Prometheus: http://localhost:9090
   * Grafana: http://localhost:3001
     EOF
cat <<'EOF' > PetraVerse/.env.example
Flask Configuration
FLASK_ENV=development
SECRET_KEY=generate_a_strong_random_secret_key
JWT_SECRET_KEY=generate_another_strong_random_secret_key
Database Configuration
DATABASE_URL=postgresql://postgres:password@db:5432/petraverse_db
Redis Configuration
REDIS_URL=redis://redis:6379/0
External APIs
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_PHONE_NUMBER=
SENDGRID_API_KEY=
SENDGRID_SENDER_EMAIL=no-reply@yourdomain.com
Blockchain Configuration
BLOCKCHAIN_NODE_URL=https://polygon-mumbai.infura.io/v3/YOUR_INFURA_PROJECT_ID
BLOCKCHAIN_PRIVATE_KEY=your_backend_wallet_private_key
PETRA_TOKEN_ADDRESS=
REPUTATION_ADDRESS=
Monitoring
SENTRY_DSN=
EOF
--- ملفات CI/CD ---
echo "-> إنشاء ملفات CI/CD..."
cat <<'EOF' > PetraVerse/.github/workflows/ci-cd.yml
name: PetraVerse CI/CD Pipeline
on:
push:
branches:
- main
pull_request:
branches:
- main
jobs:
lint-test-build:
runs-on: ubuntu-latest
steps:
- name: Checkout code
uses: actions/checkout@v3
- name: Set up Python
uses: actions/setup-python@v4
with:
python-version: '3.9'
- name: Install backend dependencies
run: |
python -m pip install --upgrade pip
pip install -r backend/requirements.txt
pip install black flake8 pytest
- name: Lint and Format Check
run: |
cd backend
flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
black --check .
- name: Run backend tests
run: |
cd backend
pytest
- name: Login to Docker Hub
if: github.event_name == 'push'
uses: docker/login-action@v2
with:
username: ${{ secrets.DOCKERHUB_USERNAME }}
password: ${{ secrets.DOCKERHUB_TOKEN }}
- name: Build and push backend image
if: github.event_name == 'push'
uses: docker/build-push-action@v4
with:
context: ./backend
file: ./backend/Dockerfile
push: true
tags: ${{ secrets.DOCKERHUB_USERNAME }}/petraverse-backend:latest
- name: Build and push frontend image
if: github.event_name == 'push'
uses: docker/build-push-action@v4
with:
context: ./frontend
file: ./frontend/Dockerfile
push: true
tags: ${{ secrets.DOCKERHUB_USERNAME }}/petraverse-frontend:latest
EOF
--- ملفات الـ Backend ---
echo "-> إنشاء ملفات الـ Backend..."
cat <<'EOF' > PetraVerse/backend/requirements.txt
Flask and extensions
Flask==2.2.3
Flask-SQLAlchemy==2.5.1
Flask-JWT-Extended==4.4.4
Flask-Cors==3.0.10
Flask-Migrate==4.0.5
Flask-SocketIO==5.3.6
Flask-Redis==0.4.0
Flasgger==0.9.5
Core libraries
cryptography==41.0.3
PyJWT==2.7.0
gunicorn==21.2.0
psycopg2-binary==2.9.6
redis==4.5.4
python-socketio
gevent-websocket
python-dotenv
AI and Machine Learning
transformers==4.31.0
torch
Blockchain
web3==6.0.0
External APIs
twilio==7.17.0
sendgrid==6.11.0
Monitoring and Error Tracking
sentry-sdk[flask]==1.39.1
Utilities
user-agents
pyotp
Testing
pytest==7.3.1
requests==2.31.0
EOF
cat <<'EOF' > PetraVerse/backend/config.py
import os
from dotenv import load_dotenv
from datetime import timedelta
basedir = os.path.abspath(os.path.dirname(file))
load_dotenv(os.path.join(basedir, '../.env'))
class Config:
SECRET_KEY = os.environ.get('SECRET_KEY')
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
SQLALCHEMY_TRACK_MODIFICATIONS = False
JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY')
REDIS_URL = os.environ.get('REDIS_URL')
SENTRY_DSN = os.environ.get('SENTRY_DSN')
# Add other configs from .env
EOF
cat <<'EOF' > PetraVerse/backend/extensions.py
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from flask_migrate import Migrate
from flask_redis import FlaskRedis
from flask_socketio import SocketIO
from flasgger import Swagger
db = SQLAlchemy()
jwt = JWTManager()
cors = CORS()
migrate = Migrate()
redis_client = FlaskRedis()
socketio = SocketIO()
swagger = Swagger()
EOF
cat <<'EOF' > PetraVerse/backend/app.py
from flask import Flask
from config import Config
from extensions import db, jwt, cors, migrate, redis_client, socketio, swagger
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration
import os
Import Blueprints
from routes.auth import auth_bp
... import all other blueprints
Import SocketIO events
import xr_events
def create_app(config_class=Config):
app = Flask(name)
app.config.from_object(config_class)
if app.config.get('SENTRY_DSN') and os.environ.get('FLASK_ENV') != 'development':
sentry_sdk.init(dsn=app.config['SENTRY_DSN'], integrations=[FlaskIntegration()], traces_sample_rate=1.0)
db.init_app(app)
jwt.init_app(app)
cors.init_app(app, resources={r"/api/": {"origins": ""}})
migrate.init_app(app, db)
redis_client.init_app(app)
socketio.init_app(app, cors_allowed_origins="*", message_queue=app.config['REDIS_URL'])
swagger.init_app(app)
app.register_blueprint(auth_bp, url_prefix='/api/auth')
# ... register all other blueprints
return app
EOF
cat <<'EOF' > PetraVerse/backend/wsgi.py
from app import create_app, socketio
app = create_app()
if name == "main":
socketio.run(app)
EOF
Create placeholder files for other backend modules
touch PetraVerse/backend/models.py
touch PetraVerse/backend/security.py
touch PetraVerse/backend/xr_events.py
touch PetraVerse/backend/routes/init.py
touch PetraVerse/backend/routes/auth.py
... and all other route/service files
--- Frontend Files ---
echo "-> إنشاء ملفات الواجهة الأمامية..."
cat <<'EOF' > PetraVerse/frontend/package.json
{
"name": "petraverse-frontend",
"version": "1.0.0",
"private": true,
"dependencies": {
"@react-three/drei": "^9.65.3",
"@react-three/fiber": "^8.13.0",
"axios": "^1.4.0",
"ethers": "^6.11.1",
"jwt-decode": "^4.0.0",
"react": "^18.2.0",
"react-dom": "^18.2.0",
"react-router-dom": "^6.11.2",
"react-scripts": "5.0.1",
"socket.io-client": "^4.7.5",
"three": "^0.152.0"
},
"scripts": {
"start": "react-scripts start",
"build": "react-scripts build",
"test": "react-scripts test",
"eject": "react-scripts eject"
},
"eslintConfig": { "extends": ["react-app", "react-app/jest"] },
"browserslist": {
"production": [">0.2%", "not dead", "not op_mini all"],
"development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
}
}
EOF
cat <<'EOF' > PetraVerse/frontend/public/index.html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8" />
<link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta name="theme-color" content="#8A2BE2" />
<meta name="description" content="PetraVerse - The Living Cultural Experience" />
<link rel="apple-touch-icon" href="%PUBLIC_URL%/logo192.png" />
<link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
<title>PetraVerse</title>
</head>
<body>
<noscript>You need to enable JavaScript to run this app.</noscript>
<div id="root"></div>
</body>
</html>
EOF
cat <<'EOF' > PetraVerse/frontend/src/App.js
import React, { useState, useEffect, Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate, Link } from "react-router-dom";
import { jwtDecode } from "jwt-decode";
import './styles/main.css';
const Auth = React.lazy(() => import("./components/Auth"));
const StudentDashboard = React.lazy(() => import("./components/StudentDashboard"));
const XRViewer = React.lazy(() => import("./components/XRViewer"));
function LoadingFallback() {
return <div className="loading-fallback">جاري التحميل...</div>;
}
function App() {
const [user, setUser] = useState(null);
useEffect(() => {
const token = localStorage.getItem("token");
if (token) {
try {
const decoded = jwtDecode(token);
setUser({ token, role: decoded.role, id: decoded.sub });
} catch (e) {
localStorage.removeItem("token");
}
}
}, []);
const handleLogin = (token) => {
localStorage.setItem("token", token);
const decoded = jwtDecode(token);
setUser({ token, role: decoded.role, id: decoded.sub });
};
const handleLogout = () => {
localStorage.removeItem("token");
setUser(null);
};
return (
<Router>
<div className="App">
<header>
<h1>PetraVerse</h1>
<nav>
{user && (
<>
<Link to="/dashboard">لوحة التحكم</Link>
<Link to="/xr">تجربة XR</Link>
<button onClick={handleLogout}>تسجيل الخروج</button>
</>
)}
</nav>
</header>
<main>
<Suspense fallback={<LoadingFallback />}>
<Routes>
<Route path="/login" element={!user ? <Auth onLogin={handleLogin} /> : <Navigate to="/dashboard" />} />
<Route path="/dashboard" element={user ? <StudentDashboard /> : <Navigate to="/login" />} />
<Route path="/xr" element={user ? <XRViewer /> : <Navigate to="/login" />} />
<Route path="/" element={<Navigate to={user ? "/dashboard" : "/login"} />} />
</Routes>
</Suspense>
</main>
</div>
</Router>
);
}
export default App;
EOF
Create placeholder files for other frontend modules
touch PetraVerse/frontend/src/index.js
touch PetraVerse/frontend/src/styles/main.css
touch PetraVerse/frontend/src/components/Auth.js
touch PetraVerse/frontend/src/components/StudentDashboard.js
touch PetraVerse/frontend/src/components/XRViewer.js
... and all other component/service files
--- Infrastructure Files ---
echo "-> إنشاء ملفات البنية التحتية..."
cat <<'EOF' > PetraVerse/infrastructure/docker-compose.yml
version: '3.9'
services:
backend:
build:
context: ../backend
dockerfile: Dockerfile
ports:
- "5000:5000"
volumes:
- ../backend:/app
env_file:
- ../.env
depends_on:
- db
- redis
restart: unless-stopped
frontend:
build:
context: ../frontend
dockerfile: Dockerfile
ports:
- "3000:3000"
volumes:
- ../frontend:/app
- /app/node_modules
depends_on:
- backend
restart: unless-stopped
db:
image: postgres:14-alpine
environment:
POSTGRES_USER: ${POSTGRES_USER}
POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
POSTGRES_DB: ${POSTGRES_DB}
volumes:
- petraverse_db_data:/var/lib/postgresql/data
restart: unless-stopped
redis:
image: redis:7-alpine
restart: unless-stopped
volumes:
petraverse_db_data:
EOF
cat <<'EOF' > PetraVerse/backend/Dockerfile
FROM python:3.9-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--worker-class", "geventwebsocket.gunicorn.workers.GeventWebSocketWorker", "wsgi:app"]
EOF
cat <<'EOF' > PetraVerse/frontend/Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF
Create placeholder files for other infrastructure modules
touch PetraVerse/infrastructure/k8s/backend-deployment.yaml
... and all other k8s files
======================================================================================
3. Finalization
======================================================================================
echo "✅✅✅ تم بنجاح إنشاء الهيكلية الكاملة لمشروع PetraVerse."
echo "الخطوات التالية:"
echo "1. انتقل إلى مجلد المشروع: cd PetraVerse"
echo "2. أنشئ ملف .env واملأ المتغيرات البيئية من .env.example."
echo "3. قم بتشغيل المشروع باستخدام: docker-compose up --build"
echo "🎉 استمتع بمنصة PetraVerse!"