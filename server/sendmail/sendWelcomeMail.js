const mailer = require("./mailer.js");

const sendWelcomeMail = async (user) => {
  try {
    const data = {
      user: user,
    };
    const body = mailer.welcomeTemplate(data);

    //console.log(body);

    const mailOptions = {
      to: [user.email],
      subject: `Welcome ${user.name} to Dalvi Farms ! `,
      body: body,
    };

    mailer
      .sendEmail(mailOptions)
      .then()
      .catch((reason) => {});
    console.log("Email sent to " + user.email);
    return true; // Return true if email is sent successfully
  } catch (error) {
    console.error("Error sending email to " + user.email + ":", error);
    return false; // Return false if there's an error sending the email
  }
};

//sendWelcomeMail();
module.exports = sendWelcomeMail;
