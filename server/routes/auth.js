const express = require("express");
const User = require("../models/user.js");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth.js");
const admin = require("../middlewares/admin.js");
const sendWelcomeMail = require("../sendmail/sendWelcomeMail.js");
const passwordResetMail = require("../sendmail/passwordResetMail.js");
const crypto = require("crypto");

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;
    if (name && email && password && phone) {
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res
          .status(400)
          .json({ msg: "User with same email already exists!" });
      }

      const hashedPassword = await bcryptjs.hash(password, 8);

      let user = new User({
        email,
        password: hashedPassword,
        name,
        phone,
      });
      user = await user.save();
      var userJson = await user.toJSON();

      if (!user) {
        return res.status(500).json({ msg: "Something Went Wrong!" });
      }

      // Send welcome email
      const success = await sendWelcomeMail(userJson);

      if (!success) {
        return res.status(500).json({ msg: "Failed to send welcome email" });
      }

      const token = jwt.sign(
        { id: user._id },
        "passwordKeyDalviFarmsRescaleAPP"
      );
      return res.json({ token, ...user._doc });
    } else {
      return res.status(400).json({ msg: "All fields are required!" });
    }
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// Sign In Route
authRouter.post("/api/signin", async (req, res) => {
  // console.log("sign in...")
  try {
    const { email, password } = req.body;
    if (email && password) {
      const user = await User.findOne({ email });
      if (!user) {
        return res
          .status(400)
          .json({ msg: "User with this email does not exist!" });
      }

      const isMatch = await bcryptjs.compare(password, user.password);
      if (!isMatch) {
        return res.status(400).json({ msg: "Incorrect password." });
      }

      const token = jwt.sign(
        { id: user._id },
        "passwordKeyDalviFarmsRescaleAPP"
      );
      // console.log(token);
      if (token) return res.json({ token, ...user._doc });
      else {
        return res.json({ token: "Token not generated!", ...user._doc });
      }
    } else {
      return res.status(400).json({ msg: "All fields are required!" });
    }
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    // console.log("Token: ", token);
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKeyDalviFarmsRescaleAPP");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// get user data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  return res.json({ ...user._doc, token: req.token });
});

authRouter.post("/changepassword", async (req, res) => {
  const { password, newpass } = req.body;
  if (password && newpass) {
    if (password !== newpass) {
      return res
        .status(400)
        .json({ msg: "Password and Confirm Password doesn't match" });
    } else {
      const hashedPassword = await bcryptjs.hash(password, 8);

      await User.findByIdAndUpdate(req.user, {
        $set: {
          password: hashedPassword,
        },
      });

      return res.status(200).json({ msg: "Password changed Successfully!" });
    }
  } else {
    return res.status(400).json({ msg: "All fields are required!" });
  }
});

authRouter.post("/updatepassword", async (req, res) => {
  const { otp, newpass, confnewpass } = req.body;
  try {
    if (otp && newpass && confnewpass) {
      // Check if new password matches confirmation
      if (newpass !== confnewpass) {
        return res.status(400).json({ msg: "Password doesn't match!" });
      }
      const user = await User.findOne({ otp: { $elemMatch: { $in: [otp] } } }); // Find user by OTP
      if (!user) {
        return res.status(404).json({ msg: "Invalid OTP!" });
      }
      // Hash the new password
      const hashedPassword = await bcryptjs.hash(newpass, 8);

      // Update the user's password and clear OTP after password update
      const updatedUser = await User.findOneAndUpdate(
        { otp: { $in: [otp] } },
        { $set: { password: hashedPassword, otp: [] } },
        { new: true }
      );
      // console.log(updatedUser);

      if (updatedUser) {
        return res.status(200).json({ msg: "Password reset successfully!" });
      } else {
        return res.status(500).json({ msg: "Password update failed!" });
      }
    } else {
      return res.status(400).json({ msg: "All fields are required!" });
    }
  } catch (error) {
    // console.error("Error resetting password:", error);
    return res.status(500).json({ msg: error.message });
  }
});

authRouter.post("/generateotp", async (req, res) => {
  const { email } = req.body;
  try {
    if (email) {
      const user = await User.findOne({ email });

      if (!user) {
        return res.status(404).json({ msg: "User not found" });
      }
      function generateOTP(length) {
        const otp = crypto
          .randomBytes(Math.ceil(length / 2))
          .toString("hex")
          .slice(0, length);
        return otp;
      }

      // Generate OTP
      const otp = generateOTP(6); // Generates a 6-digit OTP

      // Update user's OTP in the database
      const updatedUser = await User.findOneAndUpdate(
        { email },
        { $set: { otp: [...user.otp, otp] } },
        { new: true }
      );
      var updateUserJson = await updatedUser.toJSON();
      if (updatedUser) {
        // Send OTP to the user (e.g., via email)
        const success = await passwordResetMail(updateUserJson);

        if (success) {
          return res
            .status(200)
            .json({ msg: "OTP generated and sent to Email!" });
        } else {
          return res.status(500).json({ msg: "Failed to send OTP email" });
        }
      } else {
        return res.status(404).json({ msg: "Such email does not exist" });
      }
    } else {
      return res.status(400).json({ msg: "Email Required!" });
    }
  } catch (error) {
    console.error("Error generating OTP:", error);
    return res.status(500).json({ msg: error.message });
  }
});

module.exports = authRouter;
