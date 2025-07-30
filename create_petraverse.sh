# ملف التشغيل الموحد لجميع خدمات المشروع
# الإصدار: 3.8
# للتشغيل: docker-compose up -d

version: '3.8'

services:
  # 1. قاعدة بيانات PostgreSQL
  postgres:
    image: postgres:15-alpine
    container_name: nashmi_postgres
    environment:
      POSTGRES_DB: nashmi_eduverse
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database:/docker-entrypoint-initdb.d # لتحميل schema.sql عند الإنشاء
    networks:
      - nashmi_network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 2. ذاكرة التخزين المؤقت Redis
  redis:
    image: redis:7-alpine
    container_name: nashmi_redis
    ports:
      - "6379:6379"
    networks:
      - nashmi_network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 3. الخادم الخلفي (Backend API)
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: nashmi_backend
    env_file:
      - .env # تحميل متغيرات البيئة من ملف .env
    ports:
      - "8080:8080"
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - ./backend:/app
      - /app/node_modules
    networks:
      - nashmi_network
    restart: unless-stopped

  # 4. الواجهة الأمامية (Frontend)
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: nashmi_frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules
    networks:
      - nashmi_network
    restart: unless-stopped

  # 5. موزع الأحمال Nginx
  nginx:
    image: nginx:alpine
    container_name: nashmi_nginx
    ports:
      - "80:80"
    volumes:
      - ./infrastructure/nginx/nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend
    networks:
      - nashmi_network
    restart: unless-stopped

volumes:
  postgres_data:

networks:
  nashmi_network:
    driver: bridge

