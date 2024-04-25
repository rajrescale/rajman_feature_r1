const express = require("express");
const admin = require("../middlewares/admin.js");
const { Product } = require("../models/product.js");
const adminRouter = express.Router();
const Order = require("../models/order.js");
// Creating an Admin Middleware
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, sizesAndPrices, quantity, images } = req.body;

    // Construct the product object with the received data
    let product = new Product({
      name,
      description,
      quantity,
      images,
      sizesAndPrices, // Use the received sizesAndPrices data
    });

    // Save the product to the database
    product = await product.save();

    // Send the saved product data as the response
    res.json(product);
  } catch (e) {
    // Handle any errors that occur during the process
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/change-product-details", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price } = req.body;

    let product = new Product({
      name,
      description,
      images,
      price,
      quantity,
    });

    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: e.message });
  }
});

// delete the product

adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    let product = await Product.findByIdAndDelete(id);
    res.send("All went well!");
  } catch (error) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status, lastUpdate } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order.lastUpdate = lastUpdate;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity *
          orders[i].products[j].sizeAndPrice.price;
      }
    }
    // CATEGORY WISE ORDER FETCHING
    let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}
module.exports = adminRouter;
