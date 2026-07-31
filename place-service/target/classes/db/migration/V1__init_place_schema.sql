-- Enable PostGIS and pgvector extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    description_ar TEXT,
    category VARCHAR(50) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    geom GEOMETRY(POINT, 4326),
    address TEXT,
    governorate VARCHAR(100),
    opening_hours VARCHAR(255),
    entrance_price DECIMAL(10,2) DEFAULT 0,
    estimated_visit_duration INT DEFAULT 60,
    best_time_to_visit VARCHAR(100),
    family_friendly BOOLEAN DEFAULT true,
    solo_friendly BOOLEAN DEFAULT true,
    accessibility_info TEXT,
    average_rating DECIMAL(3,2) DEFAULT 0,
    review_count INT DEFAULT 0,
    embedding vector(384),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS place_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    url VARCHAR(500) NOT NULL,
    caption VARCHAR(255),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Spatial index for geom column
CREATE INDEX idx_places_geom ON places USING GIST(geom);
-- Index for category filtering
CREATE INDEX idx_places_category ON places(category);
-- Index for governorate
CREATE INDEX idx_places_governorate ON places(governorate);
-- Index for vector similarity search
CREATE INDEX idx_places_embedding ON places USING ivfflat (embedding vector_cosine_ops) WITH (lists = 20);
-- Index for photos
CREATE INDEX idx_place_photos_place_id ON place_photos(place_id);

-- Trigger to auto-update geom from lat/lon
CREATE OR REPLACE FUNCTION update_geom()
RETURNS TRIGGER AS $$
BEGIN
    NEW.geom = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_geom
    BEFORE INSERT OR UPDATE OF latitude, longitude ON places
    FOR EACH ROW EXECUTE FUNCTION update_geom();
