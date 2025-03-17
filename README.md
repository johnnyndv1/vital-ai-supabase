# Vital AI Dashboard με Supabase

Ένα σύγχρονο dashboard για την ανάλυση ιατρικών εξετάσεων με χρήση AI, βασισμένο σε Next.js και Supabase.

## Προαπαιτούμενα

- Node.js 18+
- pnpm
- Docker
- Supabase CLI
- OpenAI API key
- Google OAuth credentials

## Εγκατάσταση

1. Κλωνοποιήστε το repository:
```bash
git clone https://github.com/johnnyndv1/vital-ai-supabase.git
cd vital-ai-supabase
```

2. Εγκαταστήστε τις εξαρτήσεις:
```bash
pnpm install
```

3. Αντιγράψτε το αρχείο περιβάλλοντος:
```bash
cp .env.example .env
```

4. Συμπληρώστε τις μεταβλητές περιβάλλοντος στο .env

5. Ξεκινήστε το Supabase τοπικά:
```bash
supabase start
```

6. Εφαρμόστε τις μεταναστεύσεις της βάσης:
```bash
supabase db reset
```

7. Ξεκινήστε τον development server:
```bash
pnpm dev
```

## Δομή Βάσης Δεδομένων

### Πίνακες

- `auth.users`: Διαχείριση χρηστών (παρέχεται από το Supabase)
- `public.profiles`: Προφίλ χρηστών
- `public.medical_tests`: Ιατρικές εξετάσεις

### Πολιτικές Ασφαλείας (RLS)

- Οι χρήστες μπορούν να δουν μόνο τα δικά τους δεδομένα
- Οι διαχειριστές έχουν πλήρη πρόσβαση
- Ενεργοποιημένη προστασία σε επίπεδο γραμμής (RLS)

## Λειτουργίες

- 🔐 Αυθεντικοποίηση με Google
- 📊 Dashboard ιατρικών εξετάσεων
- 🤖 Ανάλυση εξετάσεων με AI
- 📁 Αποθήκευση αρχείων
- 👥 Διαχείριση προφίλ

## Περιβάλλον Ανάπτυξης

- Next.js 14
- Supabase
- TypeScript
- Tailwind CSS
- OpenAI API

## Άδεια Χρήσης

MIT