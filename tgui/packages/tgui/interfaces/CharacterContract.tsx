import { Box, Image } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { resolveAsset } from '../assets';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  hasPowercell: BooleanLike;
  on: BooleanLike;
  open: BooleanLike;
  anchored: BooleanLike;
  powerLevel: number;
};

export const CharacterContract = (props) => {
  const { act, data } = useBackend<Data>();
  const { Placeholder } = data;

  return (
    <Window width={1380} height={1200}>
      <Window.Content
        backgroundColor="#5b210a"
        style={{
          backgroundImage: 'none',
        }}
      >
        <Box
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '100%',
            height: '100%',
          }}
        >
          <Box
            style={{
              position: 'relative',
              width: '960px',
              height: '960px',
              flexShrink: 0,
            }}
          >
            <Image
              width={'960px'}
              height={'960px'}
              src={resolveAsset('donkcopaper.png')}
            />
            <Box
              fontSize={'16px'}
              color="green"
              style={{
                position: 'absolute',
                top: '50%',
                left: '50%',
                transform: 'translate(-50%, -50%)',
                overflow: 'hidden',
                whiteSpace: 'nowrap',
                textOverflow: 'ellipsis',
                textAlign: 'center',
              }}
            >
              You have signed a contract with the Donk Corporation. You are now
              an employee of a station.
            </Box>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
