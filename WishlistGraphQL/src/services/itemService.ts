import { v4 as uuidv4 } from 'uuid';
import { Item, ItemsQueryParams, AddItemInput, UpdateItemInput, Summary } from '../types/item';

let wishlist: Item[] = [];

export const itemService = {
  getItems({ page = 1, pageSize = 10, name, sortByPrice }: ItemsQueryParams): Item[] {
    let filtered = [...wishlist];
    
    if (name) {
      filtered = filtered.filter(item => item.name.includes(name));
    }
    
    if (sortByPrice) {
      filtered.sort((a, b) => 
        sortByPrice === 'asc' ? a.price - b.price : b.price - a.price
      );
    }
    
    const start = (page - 1) * pageSize;
    return filtered.slice(start, start + pageSize);
  },

  getSummary(): Summary {
    const totalItems = wishlist.length;
    const totalCost = wishlist.reduce((sum, item) => sum + item.price, 0);
    const averagePrice = totalItems > 0 ? totalCost / totalItems : 0;
    const mostExpensiveItem = totalItems > 0 
      ? wishlist.reduce((a, b) => a.price > b.price ? a : b) 
      : null;

    return {
      mostExpensiveItem,
      averagePrice,
      totalCost,
      totalItems
    };
  },

  addItem(input: AddItemInput): Item {
    const newItem: Item = {
      id: uuidv4(),
      ...input,
      dateAdded: new Date().toISOString()
    };
    wishlist.push(newItem);
    return newItem;
  },

  updateItem({ id, ...updates }: UpdateItemInput): Item {
    const index = wishlist.findIndex(item => item.id === id);
    if (index === -1) throw new Error('Item not found');
    
    wishlist[index] = { ...wishlist[index], ...updates };
    return wishlist[index];
  },

  deleteItem(id: string): boolean {
    const initialLength = wishlist.length;
    wishlist = wishlist.filter(item => item.id !== id);
    return wishlist.length !== initialLength;
  },
  
  getAllItems(): Item[] {
    return [...wishlist];
  }
};