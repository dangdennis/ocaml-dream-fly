CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  text TEXT NOT NULL
);

-- Specifically required as if for Dream's session middleware
CREATE TABLE dream_session (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  expires_at REAL NOT NULL,
  payload TEXT NOT NULL
);
