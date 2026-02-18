import { getSessionHandler, signInHandler, signUpHandler } from "@/features/Auth-test/auth"
import { Router } from "express"

const router = Router()

router.post("/sign-in", signInHandler)
router.post("/sign-up", signUpHandler)
router.get("/get-session", getSessionHandler)
// router.get("/get-access-token", getAccessToken)

export default router
