const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth.js");
const Order = require("../models/order");
const { Product } = require("../models/product.js");
const User = require("../models/user.js");
const orderPlacedMail = require("../sendmail/orderPlacedMail.js");

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id, sizeIndex } = req.body;
    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    let user = await User.findById(req.user);

    const sizeAndPrice = product?.sizesAndPrices?.[sizeIndex];

    if (user.cart.length === 0) {
      user.cart.push({ product, quantity: 1, sizeAndPrice });
    } else {
      let isProductFound = false;

      for (let i = 0; i < user.cart.length; i++) {
        var lineItem = user.cart[i];
        if (lineItem.product._id.equals(product._id) && (lineItem.sizeAndPrice.size === sizeAndPrice.size) ) {
          isProductFound = true;
          lineItem.quantity += 1;
          break;
        }
      }

      if (!isProductFound) {
        user.cart.push({ product, quantity: 1, sizeAndPrice });
      }
    }

    const updatedCart = user.cart.map((item) => ({
      product: item.product,
      quantity: item.quantity,
      sizeAndPrice: item.sizeAndPrice,
    }));
    user.cart = updatedCart;
    user = await user.save();

    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.delete("/api/remove-from-cart", auth, async (req, res) => {
  try {
    const { id,size } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id) && (user.cart[i].sizeAndPrice.size === size)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
userRouter.post("/api/increase-product", auth, async (req, res) => {
  try {
    const { id,size } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);


    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id) && (user.cart[i].sizeAndPrice.size === size)) {
        user.cart[i].quantity += 1;
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// save user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;
    let user = await User.findById(req.user);
    user.address = address;
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    let products = [];

    // Process each item in the cart
    for (let i = 0; i < cart.length; i++) {
      const product = await Product.findById(cart[i].product._id);
      if (!product || product.quantity < cart[i].quantity) {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock!` });
      }
      // Update product quantity and push to products array
      product.quantity -= cart[i].quantity;
      let price = cart[i].sizeAndPrice["price"];
      let size = cart[i].sizeAndPrice["size"];

      products.push({
        product,
        quantity: cart[i].quantity,
        sizeAndPrice: { price, size },
      });
      await product.save();
    }

    // Clear user's cart after processing the order
    var user = await User.findById(req.user);
    var userJson = await user.toJSON();
    user.cart = [];
    user = await user.save();

    // Create the order
    var order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    // Save the order to the database
    order = await order.save();

    var orderJson = order.toJSON();

    // Send email when order is placed (without await)
    orderPlacedMail(userJson, cart, orderJson)
      .then((emailSent) => {
        if (emailSent) {
          res.json(order); // Respond with the created order
        } else {
          // If email sending failed, respond with success but include a message
          res.status(200).json({
            order,
            msg: "Order placed successfully but failed to send email",
          });
        }
      })
      .catch((error) => {
        // Handle error while sending email
        console.error("Error sending email:", error);
        res.json(order); // Respond with the created order even if email sending failed
      });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;
