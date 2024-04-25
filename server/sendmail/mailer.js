const { SESClient, SendEmailCommand } = require("@aws-sdk/client-ses");
const { fromIni } = require("@aws-sdk/credential-provider-ini");

//templatization for e-mails
const handleBar = require("handlebars");
handleBar.create({ allowProtoMethods: true });



const fs = require("fs");
const moment = require("moment");

//Utilities to format the amount
handleBar.registerHelper("formatAmount", function (amount) {
  return `₹ ${Math.floor(amount)}`; // Assuming amount is in rupees and we want to remove decimals
});

//given a timestamp since 1971 format, It will format to string like 3 days, 2 hours ago - will be useful to place different dates
handleBar.registerHelper("formatTime", function (timestampInSeconds) {
  const currentTime = moment();
  const pastTime = moment.unix(timestampInSeconds);
  const duration = moment.duration(currentTime.diff(pastTime));

  const days = duration.days();
  const hours = duration.hours();
  const minutes = duration.minutes();

  if (days > 0 || hours > 0 || minutes > 0) {
    let result = "";
    if (days > 0) {
      result += `${days}d `;
    }
    if (hours > 0) {
      result += `${hours}h `;
    }
    if (minutes > 0) {
      result += `${minutes}m `;
    }
    return result + "ago";
  } else {
    return "just now";
  }
});

const signUpTemplateSource = fs.readFileSync(
  "sendmail/templates/welcomeUser.hbs",
  "utf8"
);
const welcomeTemplate = handleBar.compile(signUpTemplateSource);

// Read the email template file
const orderTemplateSource = fs.readFileSync(
  "sendmail/templates/orderConfirmation.hbs",
  "utf8"
);
const orderTemplate = handleBar.compile(orderTemplateSource);

const forgotPasswordSource = fs.readFileSync(
  "sendmail/templates/forgotPassword.hbs",
  "utf8"
);
const forgotPasswordTemplate = handleBar.compile(forgotPasswordSource);

// Set the AWS Region
const REGION = "eu-west-1"; // Replace with your AWS Region

// Create SES client with explicit credentials
const sesClient = new SESClient({
  region: REGION,
  credentials: {
    accessKeyId: "AKIA3EJIYO6NWPY3T6FM",
    secretAccessKey: "XxbSLNe7e8c1+AJFet9eId3yhKSPOj/QsJ81NbeF",
  },
});

// Send the email
async function _sendEmail(params) {
  try {
    const response = await sesClient.send(new SendEmailCommand(params));
    console.log("Email status:", response);
  } catch (err) {
    console.error("Error sending email:", err);
  }
}

async function sendEmail(mailOptions) {
  // Set the parameters for the email
  const params = {
    Destination: {
      ToAddresses: mailOptions.to, // Replace with recipient email address
    },
    Message: {
      Body: {
        Html: {
          Data: mailOptions.body,
        },
      },
      Subject: {
        Data: mailOptions.subject,
      },
    },
    Source: "orders@dalvifarms.com", // Replace with sender email address
  };
  return _sendEmail(params);
}

// sendEmail({ to: ["chndu6ue@gmail.com"], subject: "Hello Mr Meena", body: "I am a <b>best<b> person in the world !" });

module.exports = {
  sendEmail,
  orderTemplate,
  forgotPasswordTemplate,
  welcomeTemplate,
};
