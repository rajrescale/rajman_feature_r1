// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth.js");
const productRouter = require("./routes/product.js");
const userRouter = require("./routes/user.js");
const adminRouter = require("./routes/admin.js");
const cors = require("cors");
//  INIT
dotenv.config();
// const PORT = 80;
const PORT = process.env.PORT || 3000;

const app = express();
const DB = `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASSWORD}@cluster0.g0b73gw.mongodb.net/myDataBase?retryWrites=true&w=majority`;

app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.originalUrl}`);
  next();
});

app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Succesful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT} `);
});
