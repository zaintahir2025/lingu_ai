BEGIN;

--
-- Class AdminAuditLogRecord as table admin_audit_log
--
CREATE TABLE "admin_audit_log" (
    "id" bigserial PRIMARY KEY,
    "actorUserId" bigint,
    "action" text NOT NULL,
    "targetType" text NOT NULL,
    "targetId" text,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "admin_audit_created_idx" ON "admin_audit_log" USING btree ("createdAt");

--
-- Class AiUsageRecord as table ai_usage
--
CREATE TABLE "ai_usage" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "requestCount" bigint NOT NULL DEFAULT 0,
    "tokensUsed" bigint NOT NULL DEFAULT 0,
    "lastReset" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ai_usage_user_unique_idx" ON "ai_usage" USING btree ("userId");

--
-- Class AppUser as table app_user
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "isEmailVerified" boolean NOT NULL DEFAULT false,
    "isDisabled" boolean NOT NULL DEFAULT false,
    "dateOfBirth" timestamp without time zone,
    "role" text NOT NULL DEFAULT 'user'::text,
    "targetLanguage" text NOT NULL DEFAULT 'es'::text,
    "username" text,
    "avatarId" text,
    "knowledgeLevel" text,
    "fluencyScore" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_user_email_unique_idx" ON "app_user" USING btree ("email");

--
-- Class DailyXpRecord as table daily_xp
--
CREATE TABLE "daily_xp" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "day" timestamp without time zone NOT NULL,
    "xpEarned" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "daily_xp_unique_idx" ON "daily_xp" USING btree ("userId", "day");

--
-- Class LessonRecord as table lesson
--
CREATE TABLE "lesson" (
    "id" bigserial PRIMARY KEY,
    "topic" text NOT NULL,
    "cefrLevel" text NOT NULL,
    "orderIndex" bigint NOT NULL
);

-- Indexes
CREATE INDEX "lesson_order_idx" ON "lesson" USING btree ("orderIndex");

--
-- Class PasswordResetTokenRecord as table password_reset_token
--
CREATE TABLE "password_reset_token" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "password_reset_token_hash_unique_idx" ON "password_reset_token" USING btree ("tokenHash");

--
-- Class RefreshTokenRecord as table refresh_token
--
CREATE TABLE "refresh_token" (
    "id" bigserial PRIMARY KEY,
    "tokenHash" text NOT NULL,
    "userId" bigint NOT NULL,
    "device" text,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "refresh_token_hash_unique_idx" ON "refresh_token" USING btree ("tokenHash");
CREATE INDEX "refresh_token_user_idx" ON "refresh_token" USING btree ("userId");

--
-- Class SubscriptionRecord as table subscription
--
CREATE TABLE "subscription" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "provider" text NOT NULL,
    "externalId" text NOT NULL,
    "customerId" text,
    "status" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "subscription_external_unique_idx" ON "subscription" USING btree ("externalId");
CREATE INDEX "subscription_user_idx" ON "subscription" USING btree ("userId");

--
-- Class SupportTicketRecord as table support_ticket
--
CREATE TABLE "support_ticket" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "category" text NOT NULL,
    "subject" text NOT NULL,
    "message" text NOT NULL,
    "priority" text NOT NULL DEFAULT 'normal'::text,
    "status" text NOT NULL DEFAULT 'open'::text,
    "reply" text,
    "repliedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "support_ticket_user_idx" ON "support_ticket" USING btree ("userId");

--
-- Class UserLessonRecord as table user_lesson
--
CREATE TABLE "user_lesson" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "lessonId" bigint NOT NULL,
    "isLocked" boolean NOT NULL DEFAULT true,
    "isCompleted" boolean NOT NULL DEFAULT false,
    "currentStep" bigint NOT NULL DEFAULT 0,
    "draftJson" text,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_lesson_unique_idx" ON "user_lesson" USING btree ("userId", "lessonId");

--
-- Class UserProgressRecord as table user_progress
--
CREATE TABLE "user_progress" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "totalXp" bigint NOT NULL DEFAULT 0,
    "level" bigint NOT NULL DEFAULT 1,
    "currentStreak" bigint NOT NULL DEFAULT 0,
    "lastActivityDate" timestamp without time zone,
    "streakFreezes" bigint NOT NULL DEFAULT 0,
    "activeRoute" text,
    "activeStateJson" text,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_progress_user_unique_idx" ON "user_progress" USING btree ("userId");

--
-- Class UserVocabRecord as table user_vocab
--
CREATE TABLE "user_vocab" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "vocabWordId" bigint NOT NULL,
    "status" text NOT NULL DEFAULT 'new'::text,
    "nextReviewDate" timestamp without time zone,
    "repetitions" bigint NOT NULL DEFAULT 0,
    "easinessFactor" double precision NOT NULL DEFAULT 2.5,
    "intervalDays" bigint NOT NULL DEFAULT 0,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_vocab_unique_idx" ON "user_vocab" USING btree ("userId", "vocabWordId");

--
-- Class VerificationTokenRecord as table verification_token
--
CREATE TABLE "verification_token" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "verification_token_hash_unique_idx" ON "verification_token" USING btree ("tokenHash");

--
-- Class VocabWordRecord as table vocab_word
--
CREATE TABLE "vocab_word" (
    "id" bigserial PRIMARY KEY,
    "lessonId" bigint NOT NULL,
    "word" text NOT NULL,
    "translation" text NOT NULL,
    "audioUrl" text
);

-- Indexes
CREATE INDEX "vocab_word_lesson_idx" ON "vocab_word" USING btree ("lessonId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR linguai_backend
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('linguai_backend', '20260819123533385-linguai-initial', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260819123533385-linguai-initial', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();


COMMIT;
