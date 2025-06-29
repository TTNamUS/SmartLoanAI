from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError

# Cấu hình kết nối (thay bằng thông tin thực tế)
DB_USER = "root"
DB_PASSWORD = "root"
DB_HOST = "mariadb-tiny" #"127.0.0.1"  # hoặc "127.0.0.1" nếu kết nối từ máy host
DB_PORT = "3308"            # hoặc 3308 nếu ánh xạ qua port host
DB_NAME = "demo_bot"  # Tên database bạn muốn kết nối

# Tạo URL kết nối
DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Tạo engine
engine = create_engine(DATABASE_URL, echo=True)

# Thử kết nối
try:
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1"))
        print("✅ Kết nối thành công:", result.scalar())
except OperationalError as e:
    print("❌ Lỗi kết nối:", e)
