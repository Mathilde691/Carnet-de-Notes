– ============================================================
– SCHÉMA BASE DE DONNÉES — Carnet de Classe CE2/CM1
– À coller dans Supabase > SQL Editor > New Query
– ============================================================

– TABLE : élèves
CREATE TABLE eleves (
id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
prenom     TEXT NOT NULL,
nom        TEXT NOT NULL,
niveau     TEXT CHECK (niveau IN (‘CE2’,‘CM1’)) NOT NULL,
created_at TIMESTAMPTZ DEFAULT NOW()
);

– TABLE : compétences évaluées
CREATE TABLE competences (
id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
matiere    TEXT NOT NULL,
nom        TEXT NOT NULL,
periode    TEXT CHECK (periode IN (‘P1’,‘P2’,‘P3’,‘P4’,‘P5’)) NOT NULL,
date_eval  TEXT,
created_at TIMESTAMPTZ DEFAULT NOW()
);

– TABLE : notes
CREATE TABLE notes (
id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
user_id        UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
eleve_id       BIGINT REFERENCES eleves(id) ON DELETE CASCADE NOT NULL,
competence_id  BIGINT REFERENCES competences(id) ON DELETE CASCADE NOT NULL,
grade          TEXT CHECK (grade IN (‘A+’,‘A’,‘EA’,‘NA’,‘ABS’)) NOT NULL,
created_at     TIMESTAMPTZ DEFAULT NOW(),
updated_at     TIMESTAMPTZ DEFAULT NOW(),
UNIQUE (eleve_id, competence_id, user_id)
);

– ============================================================
– SÉCURITÉ (Row Level Security) — chaque enseignante
– ne voit QUE ses propres données
– ============================================================

ALTER TABLE eleves      ENABLE ROW LEVEL SECURITY;
ALTER TABLE competences ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes       ENABLE ROW LEVEL SECURITY;

– Policies : élèves
CREATE POLICY “Voir ses élèves”     ON eleves FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY “Ajouter ses élèves”  ON eleves FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY “Modifier ses élèves” ON eleves FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY “Supprimer ses élèves” ON eleves FOR DELETE USING (auth.uid() = user_id);

– Policies : compétences
CREATE POLICY “Voir ses compétences”      ON competences FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY “Ajouter ses compétences”   ON competences FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY “Modifier ses compétences”  ON competences FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY “Supprimer ses compétences” ON competences FOR DELETE USING (auth.uid() = user_id);

– Policies : notes
CREATE POLICY “Voir ses notes”      ON notes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY “Ajouter ses notes”   ON notes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY “Modifier ses notes”  ON notes FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY “Supprimer ses notes” ON notes FOR DELETE USING (auth.uid() = user_id);
