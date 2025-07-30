🚀 Nashmi EduVerse Nexus - نحو تعليم ذكي 1000x
📋 نظرة عامة
Nashmi EduVerse Nexus هو منصة تعليمية ذكية متكاملة مصممة خصيصاً لوزارة التربية والتعليم الأردنية. يجمع المشروع بين أحدث تقنيات الذكاء الاصطناعي، البلوك تشين، والتحليلات المتقدمة لتقديم تجربة تعليمية ثورية، وتحقيق توفير مالي يقدر بـ 11.4 مليون دينار سنوياً.
✨ المزايا الرئيسية
 * 🤖 ذكاء اصطناعي متقدم: تحليل أساليب التعلم، توصيات مخصصة، وتقييم تلقائي.
 * 📊 تحليلات شاملة: لوحات تحكم لحظية للطلاب، المعلمين، والإدارة.
 * 🔗 بلوك تشين: شهادات رقمية موثقة وعملة تعليمية (Petra Coins).
 * ⚡ أتمتة ذكية: مهام مجدولة، تقارير تلقائية، ومراقبة صحة النظام.
 * 🌐 منصة شاملة: واجهات متخصصة لكل مستخدم ودعم للعمل دون اتصال بالإنترنت.
🛠️ التقنيات المستخدمة
| الفئة | التقنيات |
|---|---|
| Backend | Node.js, Express.js, TypeScript |
| Frontend | React 18, TypeScript, Vite, Tailwind CSS |
| Database | PostgreSQL, Redis |
| AI/ML | OpenAI GPT-4, TensorFlow.js |
| Infrastructure | Docker, Kubernetes, Nginx, Prometheus, Grafana |
| Security | bcrypt, JWT, HTTPS, rate-limiting, 2FA |
🏗️ هيكل المشروع
nashmi-eduverse-nexus/
├── backend/
├── frontend/
├── database/
├── infrastructure/
├── docs/
├── .env.example
├── docker-compose.yml
└── README.md

🚀 التشغيل السريع
المتطلبات الأساسية
 * Node.js >= 18.0.0
 * Docker >= 20.10.0
 * Docker Compose >= 2.0.0
 * Git
خطوات التشغيل
 * تحميل المشروع:
   git clone <repository-url>
cd nashmi-eduverse-nexus

 * إعداد متغيرات البيئة:
   cp .env.example .env
# (تحرير ملف .env وإضافة القيم المطلوبة)

 * تشغيل النظام باستخدام Docker:
   docker-compose up -d

 * تطبيق مخطط قاعدة البيانات:
   # الانتظار لمدة 60 ثانية لتهيئة قاعدة البيانات
docker exec -i nashmi_postgres psql -U postgres -d nashmi_eduverse < database/schema.sql

 * الوصول للتطبيق:
   * الواجهة الأمامية: http://localhost:3000
   * API الخلفي: http://localhost:8080
   * Grafana (للمراقبة): http://localhost:3001 (admin/admin123)
🚢 النشر للإنتاج
يتم النشر للبيئة الإنتاجية باستخدام Kubernetes. ملفات الإعداد موجودة في مجلد infrastructure/kubernetes/.
kubectl apply -f infrastructure/kubernetes/

🔐 الأمان
 * HTTPS: شهادات SSL/TLS إلزامية.
 * JWT: مصادقة آمنة.
 * Rate Limiting: حماية من هجمات القوة الغاشمة.
 * Input Validation: التحقق من جميع مدخلات المستخدم.
 * SQL Injection Prevention: استخدام استعلامات مهيأة (Prepared Statements).
📞 التواصل والدعم
 * البريد الإلكتروني: mosabalajarma925@gmail.com
 * الهاتف: +962 7 7693 9399
 * GitHub: https://github.com/mosab320010/Nashmi-EduVerse-Nexus
🇯🇴 صُنع بفخر في الأردن لخدمة التعليم الأردني