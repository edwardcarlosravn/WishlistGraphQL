CREATE TABLE "users" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "password_hash" VARCHAR(255) NOT NULL,
  "last_password_change" TIMESTAMP,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "phone" VARCHAR(20),
  "is_manager" BOOLEAN NOT NULL DEFAULT false,
  "email_verified" BOOLEAN NOT NULL DEFAULT false,
  "is_active" BOOLEAN NOT NULL DEFAULT true,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" TIMESTAMP,
  "updated_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "products" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" VARCHAR(255) NOT NULL,
  "description" TEXT,
  "category_id" INTEGER,
  "is_active" BOOLEAN NOT NULL DEFAULT true,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "product_variations" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "product_id" UUID NOT NULL,
  "is_active" BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE "variation_images" (
  "id" SERIAL PRIMARY KEY,
  "variation_id" UUID NOT NULL,
  "image_url" VARCHAR(255) NOT NULL,
  "alt_text" VARCHAR(255),
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "product_items" (
  "id" SERIAL PRIMARY KEY,
  "variation_id" UUID NOT NULL,
  "sku" VARCHAR(50) UNIQUE NOT NULL,
  "price" DECIMAL(10,2) NOT NULL,
  "stock" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE "attributes" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE "attribute_values" (
  "id" SERIAL PRIMARY KEY,
  "attribute_id" INTEGER NOT NULL,
  "value" VARCHAR(50) NOT NULL
);

CREATE TABLE "product_item_attributes" (
  "product_item_id" INTEGER NOT NULL,
  "attribute_value_id" INTEGER NOT NULL,
  PRIMARY KEY ("product_item_id", "attribute_value_id")
);

CREATE TABLE "product_categories" (
  "id" SERIAL PRIMARY KEY,
  "parent_id" INTEGER,
  "name" VARCHAR(100) NOT NULL,
  "slug" VARCHAR(100) UNIQUE NOT NULL,
  "description" TEXT,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);
CREATE TABLE "product_category_junction" (
  "product_id" UUID NOT NULL,
  "category_id" INTEGER NOT NULL,
  PRIMARY KEY ("product_id", "category_id"),
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);
CREATE TABLE "shopping_carts" (
  "id" SERIAL PRIMARY KEY,
  "user_id" UUID NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "shopping_cart_items" (
  "id" SERIAL PRIMARY KEY,
  "cart_id" INTEGER NOT NULL,
  "product_item_id" INTEGER NOT NULL,
  "quantity" INTEGER NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "shop_orders" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "user_id" UUID NOT NULL,
  "shipping_address" VARCHAR(100) NOT NULL,
  "order_status" VARCHAR(20) NOT NULL DEFAULT 'pending',
  "order_date" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "order_total" DECIMAL(10,2) NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "order_lines" (
  "id" SERIAL PRIMARY KEY,
  "order_id" UUID NOT NULL,
  "product_item_id" INTEGER NOT NULL,
  "quantity" INTEGER NOT NULL,
  "price" DECIMAL(10,2) NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "user_favorites" (
  "id" SERIAL PRIMARY KEY,
  "user_id" UUID NOT NULL,
  "product_id" UUID NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "stripe_payment" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "payment_intent_id" VARCHAR(255) UNIQUE NOT NULL,
  "order_id" UUID NOT NULL,
  "amount" DECIMAL(10,2) NOT NULL,
  "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
  "status" VARCHAR(20) NOT NULL,
  "receipt_url" VARCHAR(255),
  "initialization_data" JSONB,
  "transaction_data" JSONB,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "stock_alerts" (
  "id" SERIAL PRIMARY KEY,
  "product_item_id" INTEGER NOT NULL,
  "user_id" UUID NOT NULL,
  "notified_at" TIMESTAMP,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

ALTER TABLE "product_variations" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE;

ALTER TABLE "product_items" ADD FOREIGN KEY ("variation_id") REFERENCES "product_variations" ("id") ON DELETE CASCADE;

ALTER TABLE "attribute_values" ADD FOREIGN KEY ("attribute_id") REFERENCES "attributes" ("id");

ALTER TABLE "product_item_attributes" ADD FOREIGN KEY ("product_item_id") REFERENCES "product_items" ("id") ON DELETE CASCADE;

ALTER TABLE "product_item_attributes" ADD FOREIGN KEY ("attribute_value_id") REFERENCES "attribute_values" ("id");

ALTER TABLE "products" ADD FOREIGN KEY ("category_id") REFERENCES "product_categories" ("id") ON DELETE SET NULL;

ALTER TABLE "variation_images" ADD FOREIGN KEY ("variation_id") REFERENCES "product_variations" ("id") ON DELETE CASCADE;

ALTER TABLE "product_categories" ADD FOREIGN KEY ("parent_id") REFERENCES "product_categories" ("id");

ALTER TABLE "shopping_carts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "shopping_cart_items" ADD FOREIGN KEY ("cart_id") REFERENCES "shopping_carts" ("id") ON DELETE CASCADE;

ALTER TABLE "shopping_cart_items" ADD FOREIGN KEY ("product_item_id") REFERENCES "product_items" ("id") ON DELETE CASCADE;

ALTER TABLE "shop_orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "order_lines" ADD FOREIGN KEY ("order_id") REFERENCES "shop_orders" ("id") ON DELETE CASCADE;

ALTER TABLE "order_lines" ADD FOREIGN KEY ("product_item_id") REFERENCES "product_items" ("id") ON DELETE CASCADE;

ALTER TABLE "user_favorites" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "user_favorites" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE;

ALTER TABLE "stripe_payment" ADD FOREIGN KEY ("order_id") REFERENCES "shop_orders" ("id") ON DELETE SET NULL;

ALTER TABLE "stock_alerts" ADD FOREIGN KEY ("product_item_id") REFERENCES "product_items" ("id") ON DELETE CASCADE;

ALTER TABLE "stock_alerts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "product_category_junction" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE CASCADE;

ALTER TABLE "product_category_junction" ADD FOREIGN KEY ("category_id") REFERENCES "product_categories" ("id") ON DELETE CASCADE;

ALTER TABLE shop_orders ADD CONSTRAINT valid_status CHECK ( order_status IN ('pending', 'processing', 'completed', 'cancelled'));