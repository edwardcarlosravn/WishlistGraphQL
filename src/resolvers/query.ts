import { itemService } from '../services/itemService';

const query = {
  Query: {
    items: (_: any, args: any) => {
      return itemService.getItems({
        page: args.page,
        pageSize: args.pageSize,
        name: args.name,
        sortByPrice: args.sortByPrice
      });
    },
    summary: () => {
      return itemService.getSummary();
    }
  }
};

export default query;