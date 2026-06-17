import {
  createContext,
  type Dispatch,
  type SetStateAction,
  useContext,
} from 'react';

import type { Item } from './GenericUplink';

type CurrentItem = {
  currentItem: Item | undefined;
  setCurrentItem: Dispatch<SetStateAction<Item | undefined>>;
};

export const CurrentItemContext = createContext({} as CurrentItem);

export function useCurrentItemContext() {
  return useContext(CurrentItemContext);
}
