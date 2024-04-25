// const fs = require("fs");
const mailer = require("./mailer.js");
// const path = require("path");

// Read the HTML template file
// const htmlContent = fs.readFileSync(path.join(__dirname, "email.html"), "utf8");

const orderPlacedMail = async (user, cart, order) => {
  /*  const order = {
        "_id": "661a63324f4b2d9ca1b31650",
        "products": [
            {
                "product": {
                    "name": "Test Product",
                    "description": "Don't checkout",
                    "images": [
                        "https://res.cloudinary.com/drixhjpsy/image/upload/v1713003164/ct6akdb4gz71jk0dooq0.jpg"
                    ],
                    "quantity": 998,
                    "price": 540,
                    "_id": "661a5ab172b22dbcaaebc3f6",
                    "__v": 0
                },
                "quantity": 1,
                "_id": "661a63324f4b2d9ca1b31651"
            }
        ],
        "totalPrice": 540,
        "address": "Majestica C 803, Casa Bella, Kalyan Shil Road, Palava, Thane -Pin 421204,Phone 9820871088",
        "userId": "661a5ae772b22dbcaaebc3fd",
        "orderedAt": 1713005362690,
        "status": 0,
        "lastUpdate": 1713005362773,
        "__v": 0
    };

    const user = {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MWE1YWU3NzJiMjJkYmNhYWViYzNmZCIsImlhdCI6MTcxMzEwNjM1NH0.oxWsHbBL6XQdpP1MY8tfLOj6fYejrZSTRzTB0YTDgso",
        "_id": "661a5ae772b22dbcaaebc3fd",
        "name": "Chandra Singh Meenw",
        "otp": [],
        "phone": "9820871088",
        "email": "chndu6ue@gmail.com",
        "password": "$2a$08$E./4Af9Gn0o.Y0/14mBMxuBaL8Z/rfiM79NVaykQoFsHixgJgs4XS",
        "address": "Majestica C 803, Casa Bella, Kalyan Shil Road, Palava, Thane -Pin 421204,Phone 9820871088",
        "type": "user",
        "cart": [],

    }; */

  const dayNames = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  const orderDate = new Date(order?.orderedAt);
  const dayName = dayNames[orderDate.getDay()]; // Get the day name
  const dayOfMonth = orderDate.getDate(); // Get the day of the month
  const month = orderDate.toLocaleString("default", { month: "long" }); // Get the month name

  let sum = order.totalPrice;
  let modifiedProducts = [];
  order.products.forEach((product) => {
    // Calculate the total price for the current product
    let totalPrice = product.quantity * product.sizeAndPrice.price;

    // Create a new object with the desired format
    let modifiedProduct = {
      product: product.product,
      quantity: product.quantity,
      sizeAndPrice: product.sizeAndPrice,
      totalPrice: totalPrice,
    };

    // Push the modified product to the array
    modifiedProducts.push(modifiedProduct);
  });
  const data = {
    dayName: dayName,
    dayOfMonth: dayOfMonth,
    month: month,
    total: sum,
    order: {
      ...order,
      products: modifiedProducts,
    },
    user: user,
  };

  const body = mailer.orderTemplate(data);

  // console.log(body)

  try {
    const mailOptions = {
      to: [user.email],
      subject: `Thank you ! Order Confirmation - ${order._id} `,
      body: body,
    };
    await mailer.sendEmail(mailOptions);
    console.log("Email sent to " + user.email + ": ");
    return true; // Return true if email is sent successfully
  } catch (error) {
    console.error("Error sending email to " + user.email + ":", error);
    return false; // Return false if there's an error sending the email
  }
};

//orderPlacedMail();

module.exports = orderPlacedMail;
