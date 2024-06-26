const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth.js");
const { Product } = require("../models/product.js");

productRouter.get("/api/products", async (req, res) => {
  try {
    const products = await Product.find({});
    return res.json(products);
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// create a get request to search products and get them

productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = productRouter;
