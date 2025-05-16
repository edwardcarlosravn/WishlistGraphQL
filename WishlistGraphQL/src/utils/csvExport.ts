import { stringify } from 'csv-stringify';
import { itemService } from '../services/itemService';
import express from 'express';

export function setupCsvExport(app: express.Application) {
  app.get('/export/wishlist', (req, res) => {
    const items = itemService.getAllItems();
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename=wishlist.csv');
    
    const stringifier = stringify({
      header: true,
      columns: ['id', 'name', 'price', 'stock', 'store', 'dateAdded']
    });
    
    stringifier.pipe(res);
    
    items.forEach(item => stringifier.write(item));
    stringifier.end();
  });
}