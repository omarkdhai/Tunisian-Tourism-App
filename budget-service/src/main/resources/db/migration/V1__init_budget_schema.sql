CREATE TABLE IF NOT EXISTS trip_budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL,
    user_id UUID NOT NULL,
    total_budget DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'TND',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(trip_id)
);

CREATE TABLE IF NOT EXISTS budget_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_budget_id UUID NOT NULL REFERENCES trip_budgets(id) ON DELETE CASCADE,
    category VARCHAR(50) NOT NULL,
    allocated_amount DECIMAL(10,2) DEFAULT 0,
    spent_amount DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(trip_budget_id, category)
);

CREATE TABLE IF NOT EXISTS expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_budget_id UUID NOT NULL REFERENCES trip_budgets(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES budget_categories(id),
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'TND',
    amount_in_tnd DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL,
    place_id UUID,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_trip_budgets_trip_id ON trip_budgets(trip_id);
CREATE INDEX idx_trip_budgets_user_id ON trip_budgets(user_id);
CREATE INDEX idx_expenses_trip_budget_id ON expenses(trip_budget_id);
