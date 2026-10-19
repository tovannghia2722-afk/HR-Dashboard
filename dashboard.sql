-- 1. Bảng User Profiles & Phân quyền (Workspace RBAC)
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  role TEXT CHECK (role IN ('admin', 'manager', 'analyst')) DEFAULT 'analyst',
  workspace_domain TEXT NOT NULL DEFAULT 'company.com',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Bảng Danh mục Sản phẩm (Products)
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  price NUMERIC(12, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Bảng Đơn hàng (Orders) - Kích hoạt Supabase Realtime
CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id),
  customer_name TEXT NOT NULL,
  total_amount NUMERIC(12, 2) NOT NULL,
  status TEXT CHECK (status IN ('Pending', 'Completed', 'Cancelled')) DEFAULT 'Completed',
  workspace_domain TEXT NOT NULL DEFAULT 'company.com',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Bảng Chi tiết Đơn hàng (Order Items)
CREATE TABLE public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id),
  quantity INT NOT NULL,
  unit_price NUMERIC(12, 2) NOT NULL
);

-- Bật tính năng Realtime Replication trên Supabase cho Bảng Orders
ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;