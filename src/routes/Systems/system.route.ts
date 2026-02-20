import {
	createCompanySystemHandler,
	getCompanySystemByIDHandler,
	getCompanySystemsHandler,
	updateCompanySystemHandler,
} from "@/features/Systems/system.controller"
import { Router } from "express"

const router = Router()

router.get("/", getCompanySystemsHandler)
router.get("/:id", getCompanySystemByIDHandler)
router.post("/", createCompanySystemHandler)
router.patch("/:id", updateCompanySystemHandler)

export default router
