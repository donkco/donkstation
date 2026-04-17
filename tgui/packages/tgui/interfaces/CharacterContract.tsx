import '../styles/interfaces/CharacterContract.scss';

import { Box, Image, Input } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

const RedactedText = ({ text }: { text?: string }) => {
  const parts = (text ?? '').split(/(\(\(.*?\)\))/g);
  return (
    <>
      {parts.map((part, i) => {
        const match = part.match(/^\(\((.*?)\)\)$/);
        if (match) {
          return (
            <span key={i} className="CharacterContract__redacted">
              {match[1]}
            </span>
          );
        }
        return <span key={i}>{part}</span>;
      })}
    </>
  );
};

type TraitColumnProps = {
  title?: string;
  description?: string;
  highlighter?: string;
};

const TraitColumn = ({ title, description, highlighter }: TraitColumnProps) => (
  <div className="CharacterContract__trait">
    <div className="CharacterContract__trait-title">
      {highlighter && (
        <img
          src={highlighter}
          className="CharacterContract__trait-highlighter"
          alt=""
        />
      )}
      <span className="CharacterContract__trait-title-text">{title}</span>
    </div>
    <div className="CharacterContract__trait-body">
      <RedactedText text={description} />
    </div>
  </div>
);

type Data = {
  trait_title_1?: string;
  trait_desc_1?: string;
  trait_title_2?: string;
  trait_desc_2?: string;
  trait_title_3?: string;
  trait_desc_3?: string;
};

export const CharacterContract = (props) => {
  const { data } = useBackend<Data>();
  const {
    trait_title_1,
    trait_title_2,
    trait_title_3,
    trait_desc_1,
    trait_desc_2,
    trait_desc_3,
  } = data;

  return (
    <Window width={1380} height={1200}>
      <Window.Content
        backgroundColor="#5b210a"
        style={{ backgroundImage: 'none' }}
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
          <div className="CharacterContract CharacterContract__canvas">
            <Image
              width="960px"
              height="960px"
              src={resolveAsset('donkcopaper.png')}
            />

            {/* Applicant Information table */}
            <div
              className="CharacterContract__overlay CharacterContract__table"
              style={{ top: '180px', left: '68px', width: '824px' }}
            >
              <div className="CharacterContract__table-header">
                Applicant Information
              </div>

              {/* Row 1: First / Last name */}
              <div className="CharacterContract__table-row CharacterContract__table-row--bordered">
                <div className="CharacterContract__table-cell CharacterContract__table-cell--right-border">
                  <span className="CharacterContract__table-label">
                    First name:
                  </span>
                  <Input fluid placeholder="First name" />
                </div>
                <div className="CharacterContract__table-cell">
                  <span className="CharacterContract__table-label">
                    Last Name:
                  </span>
                  <Input fluid placeholder="Last name" />
                </div>
              </div>

              {/* Row 2: Date of birth / Title radio buttons */}
              <div className="CharacterContract__table-row CharacterContract__table-row--bordered">
                <div className="CharacterContract__table-cell CharacterContract__table-cell--right-border CharacterContract__table-cell--dob">
                  <span className="CharacterContract__table-label">
                    Date of birth:
                  </span>
                  <Input width="36px" placeholder="DD" />
                  <span>/</span>
                  <Input width="36px" placeholder="MM" />
                  <span>/</span>
                  <Input width="54px" placeholder="YYYY" />
                </div>
                <div className="CharacterContract__table-cell CharacterContract__table-cell--titles">
                  <label className="CharacterContract__radio-label">
                    <input type="radio" name="title" value="Mr" /> Mr
                  </label>
                  <label className="CharacterContract__radio-label">
                    <input type="radio" name="title" value="Mrs" /> Mrs
                  </label>
                  <label className="CharacterContract__radio-label">
                    <input type="radio" name="title" value="Ms" /> Ms
                  </label>
                </div>
              </div>

              {/* Row 3: Place of birth */}
              <div className="CharacterContract__table-cell">
                <span className="CharacterContract__table-label">
                  Place of birth:
                </span>
                <Input fluid placeholder="Place of birth" />
              </div>
            </div>

            {/* Section title */}
            <div
              className="CharacterContract__overlay CharacterContract__section-title"
              style={{ top: '420px', left: '68px', width: '824px' }}
            >
              Donk Co. Integrative Character Evalutation
            </div>

            {/* Three evaluation columns */}
            <div
              className="CharacterContract__overlay CharacterContract__columns"
              style={{ top: '460px', left: '68px', width: '824px' }}
            >
              <TraitColumn
                title={trait_title_1}
                description={trait_desc_1}
                highlighter={resolveAsset('green_highlighter.png')}
              />
              <TraitColumn
                title={trait_title_2}
                description={trait_desc_2}
                highlighter={resolveAsset('red_highlighter.png')}
              />
              <TraitColumn title={trait_title_3} description={trait_desc_3} />
            </div>
          </div>
        </Box>
      </Window.Content>
    </Window>
  );
};
