BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "lesson" ADD COLUMN "languageCode" text NOT NULL DEFAULT 'es'::text;
ALTER TABLE "lesson" ADD COLUMN "unitNumber" bigint NOT NULL DEFAULT 1;
ALTER TABLE "lesson" ADD COLUMN "grammarNote" text NOT NULL DEFAULT ''::text;
ALTER TABLE "lesson" ADD COLUMN "status" text NOT NULL DEFAULT 'approved'::text;
CREATE INDEX "lesson_language_idx" ON "lesson" USING btree ("languageCode");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_lesson" ADD COLUMN "bestScore" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_lesson" ADD COLUMN "attempts" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_lesson" ADD COLUMN "completedAt" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_progress" ADD COLUMN "gemsCount" bigint NOT NULL DEFAULT 100;
ALTER TABLE "user_progress" ADD COLUMN "longestStreak" bigint NOT NULL DEFAULT 0;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_vocab" ADD COLUMN "errorCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_vocab" ADD COLUMN "lastReviewedAt" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "vocab_word" ADD COLUMN "exampleSentence" text;
ALTER TABLE "vocab_word" ADD COLUMN "exampleTranslation" text;
ALTER TABLE "vocab_word" ADD COLUMN "partOfSpeech" text NOT NULL DEFAULT 'phrase'::text;
ALTER TABLE "vocab_word" ADD COLUMN "ipa" text;
ALTER TABLE "vocab_word" ADD COLUMN "cefrLevel" text NOT NULL DEFAULT 'A1'::text;
ALTER TABLE "vocab_word" ADD COLUMN "orderIndex" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR linguai_backend
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('linguai_backend', '20260819125424605-learning-parity', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260819125424605-learning-parity', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();


COMMIT;
