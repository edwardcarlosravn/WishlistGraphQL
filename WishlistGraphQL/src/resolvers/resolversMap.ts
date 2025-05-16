import query from './query';
import mutation from './mutation';

const resolversMap = {
  ...query,
  ...mutation
};

export default resolversMap;