-- CreateEnum
CREATE TYPE "SystemStatus" AS ENUM ('ACTIVE', 'DISABLED', 'MAINTENANCE');

-- CreateEnum
CREATE TYPE "PersonalSystemStatus" AS ENUM ('ACTIVE', 'DISABLED');

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'EMPLOYEE');

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "idToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "refreshTokenExpiresAt" TIMESTAMP(3),
    "scope" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "systems" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "image" TEXT,
    "url" TEXT NOT NULL,
    "status" "SystemStatus" NOT NULL DEFAULT 'ACTIVE',
    "creator_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "systems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_department_map" (
    "system_id" UUID NOT NULL,
    "department_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "system_department_map_pkey" PRIMARY KEY ("system_id","department_id")
);

-- CreateTable
CREATE TABLE "user_profiles" (
    "user_id" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'EMPLOYEE',
    "department_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_profiles_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "personal_systems" (
    "id" UUID NOT NULL,
    "owner_user_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "image" TEXT,
    "url" TEXT NOT NULL,
    "status" "PersonalSystemStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "personal_systems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_favorite_systems" (
    "user_id" TEXT NOT NULL,
    "system_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_favorite_systems_pkey" PRIMARY KEY ("user_id","system_id")
);

-- CreateTable
CREATE TABLE "user_favorite_personal_systems" (
    "user_id" TEXT NOT NULL,
    "personal_system_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_favorite_personal_systems_pkey" PRIMARY KEY ("user_id","personal_system_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE INDEX "session_userId_idx" ON "session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "session"("token");

-- CreateIndex
CREATE INDEX "account_userId_idx" ON "account"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "account_providerId_accountId_key" ON "account"("providerId", "accountId");

-- CreateIndex
CREATE INDEX "verification_identifier_idx" ON "verification"("identifier");

-- CreateIndex
CREATE INDEX "systems_status_idx" ON "systems"("status");

-- CreateIndex
CREATE INDEX "systems_creator_id_idx" ON "systems"("creator_id");

-- CreateIndex
CREATE UNIQUE INDEX "systems_url_key" ON "systems"("url");

-- CreateIndex
CREATE UNIQUE INDEX "departments_name_key" ON "departments"("name");

-- CreateIndex
CREATE INDEX "system_department_map_department_id_idx" ON "system_department_map"("department_id");

-- CreateIndex
CREATE INDEX "user_profiles_role_idx" ON "user_profiles"("role");

-- CreateIndex
CREATE INDEX "user_profiles_department_id_idx" ON "user_profiles"("department_id");

-- CreateIndex
CREATE INDEX "personal_systems_owner_user_id_idx" ON "personal_systems"("owner_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "personal_systems_owner_user_id_url_key" ON "personal_systems"("owner_user_id", "url");

-- CreateIndex
CREATE INDEX "user_favorite_systems_system_id_idx" ON "user_favorite_systems"("system_id");

-- CreateIndex
CREATE INDEX "user_favorite_personal_systems_personal_system_id_idx" ON "user_favorite_personal_systems"("personal_system_id");

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "systems" ADD CONSTRAINT "systems_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_department_map" ADD CONSTRAINT "system_department_map_system_id_fkey" FOREIGN KEY ("system_id") REFERENCES "systems"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_department_map" ADD CONSTRAINT "system_department_map_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_profiles" ADD CONSTRAINT "user_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_profiles" ADD CONSTRAINT "user_profiles_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personal_systems" ADD CONSTRAINT "personal_systems_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_favorite_systems" ADD CONSTRAINT "user_favorite_systems_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_favorite_systems" ADD CONSTRAINT "user_favorite_systems_system_id_fkey" FOREIGN KEY ("system_id") REFERENCES "systems"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_favorite_personal_systems" ADD CONSTRAINT "user_favorite_personal_systems_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_favorite_personal_systems" ADD CONSTRAINT "user_favorite_personal_systems_personal_system_id_fkey" FOREIGN KEY ("personal_system_id") REFERENCES "personal_systems"("id") ON DELETE CASCADE ON UPDATE CASCADE;
