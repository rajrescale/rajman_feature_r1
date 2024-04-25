const mailer = require("./mailer.js");

const passwordResetMail = async (user) => {
  try {
    const data = {
      user: user,
    };
    const body = mailer.forgotPasswordTemplate(data);
    const mailOptions = {
      to: [user.email],
      subject: `OTP : Reset Password ${user.name}`,
      body: body,
    };
    const info = await mailer.sendEmail(mailOptions);
    console.log("Email sent to " + user.email + ": ");
    return true; // Return true if email is sent successfully
  } catch (error) {
    console.error("Error sending email to " + user.email + ":", error);
    return false; // Return false if there's an error sending the email
  }
};

//passwordResetMail();

module.exports = passwordResetMail;
