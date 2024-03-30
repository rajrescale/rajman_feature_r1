// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth.js");
const productRouter = require("./routes/product.js");
const userRouter = require("./routes/user.js");
const adminRouter = require("./routes/admin.js");
const cors = require("cors");
const https = require("https");
const fs = require("fs");
const PORT = 443;
const app = express();
const DB =
  process.env.MONGODB_URI ||
  "mongodb+srv://rajmanbind3535:FuCAVzw1GxtDWSUE@cluster0.g0b73gw.mongodb.net/myDataBase?retryWrites=true&w=majority";


// Middleware to log request details
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.originalUrl}`);
  next();
});
// middleware
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Succesful");
  })
  .catch((e) => {
    console.log(e);
  });


const server = https.createServer(
{
    key: fs.readFileSync("../certificate/key.pem"),
    cert: fs.readFileSync("../certificate/cert.pem"),
},  
  app
);
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// app.listen(PORT, "0.0.0.0", () => {
//   console.log(`connected at port ${PORT} `);
// });

module.exports = app;
