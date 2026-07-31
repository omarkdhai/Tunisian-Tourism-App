CREATE TABLE IF NOT EXISTS trips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    arrival_airport VARCHAR(100),
    departure_airport VARCHAR(100),
    arrival_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    duration_days INT NOT NULL,
    budget DECIMAL(10,2),
    travel_style VARCHAR(50),
    preferred_transportation VARCHAR(50),
    status VARCHAR(50) DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS trip_days (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    day_number INT NOT NULL,
    date DATE NOT NULL,
    estimated_cost DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    UNIQUE(trip_id, day_number)
);

CREATE TABLE IF NOT EXISTS trip_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_day_id UUID NOT NULL REFERENCES trip_days(id) ON DELETE CASCADE,
    place_id UUID NOT NULL,
    order_index INT NOT NULL,
    start_time TIME,
    end_time TIME,
    duration INT NOT NULL,
    travel_time_from_prev INT,
    distance_from_prev DOUBLE PRECISION,
    transport_mode VARCHAR(50),
    estimated_cost DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'PLANNED',
    notes TEXT
);

CREATE TABLE IF NOT EXISTS hotel_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_day_id UUID REFERENCES trip_days(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    lat DOUBLE PRECISION,
    lon DOUBLE PRECISION,
    price_per_night DECIMAL(10,2),
    rating DECIMAL(3,2)
);

CREATE TABLE IF NOT EXISTS restaurant_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_day_id UUID REFERENCES trip_days(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    lat DOUBLE PRECISION,
    lon DOUBLE PRECISION,
    cuisine VARCHAR(100),
    price_range VARCHAR(50),
    rating DECIMAL(3,2)
);

CREATE INDEX idx_trips_user_id ON trips(user_id);
CREATE INDEX idx_trip_days_trip_id ON trip_days(trip_id);
CREATE INDEX idx_trip_activities_trip_day_id ON trip_activities(trip_day_id);
