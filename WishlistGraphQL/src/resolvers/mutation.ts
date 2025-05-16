import { itemService } from '../services/itemService';

const mutation = {
  Mutation: {
    addItem: (_: any, args: any) => {
      return itemService.addItem({
        name: args.name,
        price: args.price,
        stock: args.stock,
        store: args.store
      });
    },
    updateItem: (_: any, args: any) => {
      return itemService.updateItem({
        id: args.id,
        name: args.name,
        price: args.price,
        stock: args.stock,
        store: args.store
      });
    },
    deleteItem: (_: any, { id }: any) => {
      return itemService.deleteItem(id);
    }
  }
};

export default mutation;