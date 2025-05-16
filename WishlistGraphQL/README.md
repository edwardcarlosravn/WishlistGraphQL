# WishlistGraphQL
Create a GraphQL API to manage a wishlist

## Description

Users should be able to add, view, update, and delete items from their wishlist. Each element within the wishlist should have an id, name, price, stock and store in which you can find it, also the date in which it was added to the list.

## Core Requirements

**Use ExpressJS**.
**Wishlist data should be managed in memory**
**Implement CRUD Operations:**
   * **Create**: Add items.
   * **Read**: View all wishlist items (Include Pagination + Filters by Name and Sorting by Price).
   * **Update**: Edit an existing item.
   * **Delete**: Remove an item.


The GraphQL API will be accessible at `http://localhost:4000/graphql`

### Using Docker

```bash
npm run docker:build

npm run docker:run
```

## Using the CSV Export Feature

To export your wishlist as a CSV file, simply access the following URL in your browser:

```
http://localhost:4000/export/wishlist
```

This will automatically download a CSV file containing all items in your wishlist with columns for id, name, price, stock, store, and date added.

## Example GraphQL Operations

```graphql
mutation {
  addItem(
    name: "Gaming Laptop", 
    price: 1299.99, 
    stock: 5, 
    store: "Electronics Store"
  ) {
    id
    name
    price
  }
}

query {
  items {
    id
    name
    price
  }
}

query {
  summary {
    totalItems
    totalCost
    averagePrice
    mostExpensiveItem {
      name
      price
    }
  }
}
```