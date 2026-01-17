-- 1. Create Tables Table
create table tables (
  id text primary key,
  name text not null,
  capacity int not null,
  is_occupied boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. Create Orders Table
create table orders (
  id text primary key,
  table_id text references tables(id),
  status text not null, -- pending, cooking, ready, served, paid
  total_amount decimal not null,
  items jsonb, -- Stores array of {menuId, quantity, remarks}
  timestamp timestamp with time zone default timezone('utc'::text, now())
);

-- 3. Enable Realtime for these tables
alter publication supabase_realtime add table tables;
alter publication supabase_realtime add table orders;

-- 4. Seed Initial Data (The 10 Tables)
insert into tables (id, name, capacity) values 
('t1', 'Table 1', 4),
('t2', 'Table 2', 4),
('t3', 'Table 3', 4),
('t4', 'Table 4', 4),
('t5', 'Table 5', 4),
('t6', 'Table 6', 4),
('t7', 'Table 7', 4),
('t8', 'Table 8', 4),
('t9', 'Table 9', 4),
('t10', 'Table 10', 4);
