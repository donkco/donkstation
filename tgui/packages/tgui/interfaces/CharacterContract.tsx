import '../styles/interfaces/CharacterContract.scss';

import { useEffect, useRef, useState } from 'react';

import { Box, Image, Input, NumberInput } from 'tgui-core/components';

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

type ArchetypeEntry = {
  name: string;
  id: string;
  cost: number;
  affordable: boolean;
};

type Data = {
  // Archetype picker
  archetypes?: ArchetypeEntry[];
  selected_archetype?: string | null;
  character_created?: boolean;
  secretary_points?: number;
  // Contract details
  trait_title_1?: string;
  trait_desc_1?: string;
  trait_title_2?: string;
  trait_desc_2?: string;
  trait_title_3?: string;
  trait_desc_3?: string;
  first_name?: string;
  last_name?: string;
  age?: number;
  place_of_birth?: string;
  gender?: string;
};

const GENDER_OPTIONS = [
  { value: 'male', label: 'He/Him' },
  { value: 'female', label: 'She/Her' },
  { value: 'plural', label: 'They/Them' },
  { value: 'neuter', label: 'It/Its' },
] as const;

// ── Page 1: Archetype picker ──────────────────────────────────────────────────

// Duration must match the $cc-stamp-duration SCSS variable (ms)
const STAMP_DURATION_MS = 950;

const ArchetypePage = () => {
  const { data, act } = useBackend<Data>();
  const { archetypes = [], selected_archetype, secretary_points = 0 } = data;
  const [stamping, setStamping] = useState(false);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Close the custom dropdown when clicking outside of it
  useEffect(() => {
    if (!dropdownOpen) return;
    const onMouseDown = (e: MouseEvent) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(e.target as Node)
      ) {
        setDropdownOpen(false);
      }
    };
    document.addEventListener('mousedown', onMouseDown);
    return () => document.removeEventListener('mousedown', onMouseDown);
  }, [dropdownOpen]);

  const selectedArch = archetypes.find((a) => a.id === selected_archetype);
  const canConfirm =
    !!selected_archetype && !stamping && (selectedArch?.affordable ?? false);

  const handleConfirm = () => {
    if (stamping) return;
    if (!selectedArch?.affordable) return;
    setStamping(true);
    act('play_stamp_sound');
    setTimeout(() => act('confirm_archetype'), STAMP_DURATION_MS + 50);
  };

  return (
    <div className="CharacterContract CharacterContract__canvas">
      <Image
        width="960px"
        height="960px"
        src={resolveAsset('donkcopaper.png')}
      />

      {/* SP balance box — above the paper, top-right */}
      <div
        className="CharacterContract__overlay CharacterContract__sp-box"
        style={{ top: '-50px', right: '60px' }}
      >
        <span className="CharacterContract__sp-box-label">
          Secretary Points
        </span>
        <span className="CharacterContract__sp-box-value">
          {secretary_points} SP
        </span>
      </div>

      {/* Memo body */}
      <div
        className="CharacterContract__overlay CharacterContract__memo-body"
        style={{ top: '160px', left: '68px', width: '824px', height: '540px' }}
      >
        <p>To whom it may concern,</p>
        <p>
          We have received your inquiry regarding a position within the Donk Co.
          family. Before any formal evaluation can proceed, we require that you
          select the classification under which your application will be
          assessed.
        </p>
        <p>
          Each classification reflects a distinct professional profile and
          carries its own associated costs. Once selected and confirmed, this
          classification is permanent and cannot be altered. Please review your
          options carefully before committing.
        </p>
        <p>
          The relevant personnel files have been prepared for your review below.
          Mark your selection, sign where indicated, and return this form to the
          appropriate office at your earliest convenience.
        </p>
        <p>We look forward to a productive working relationship.</p>
        <p style={{ fontStyle: 'normal', fontWeight: 'bold' }}>
          — Donk Co. Human Resources Division
        </p>
      </div>

      {/* Circle/question-mark overlay — positioned on the canvas */}
      <img
        src={resolveAsset('circle_questionmarks.png')}
        className="CharacterContract__overlay CharacterContract__archetype-overlay"
        style={{ bottom: '260px', right: '60px' }}
        alt=""
      />

      {/* Archetype dropdown + overlay */}
      <div
        className="CharacterContract__overlay"
        style={{ bottom: '230px', right: '260px' }}
      >
        <div className="CharacterContract__archetype-picker" ref={dropdownRef}>
          {/* Custom dropdown — avoids BYOND native <select> focus loss after alt-tab */}
          <div
            className={
              'CharacterContract__archetype-trigger' +
              (dropdownOpen ? ' is-open' : '')
            }
            onMouseDown={() => setDropdownOpen((o) => !o)}
          >
            <span>{selectedArch ? selectedArch.name : 'Classification'}</span>
            <span className="CharacterContract__archetype-arrow">▾</span>
          </div>
          {dropdownOpen && (
            <div className="CharacterContract__archetype-list">
              {archetypes.map((arch) => (
                <div
                  key={arch.id}
                  className={
                    'CharacterContract__archetype-option' +
                    (!arch.affordable ? ' is-disabled' : '') +
                    (arch.id === selected_archetype ? ' is-selected' : '')
                  }
                  onMouseDown={() => {
                    if (!arch.affordable) return;
                    act('select_archetype', { id: arch.id });
                    setDropdownOpen(false);
                  }}
                >
                  <span>{arch.name}</span>
                  <span className="CharacterContract__archetype-cost">
                    {arch.cost}&nbsp;SP{!arch.affordable ? ' ✕' : ''}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>

        <button
          className="CharacterContract__archetype-confirm"
          style={{ marginTop: '60px' }}
          disabled={!canConfirm}
          onClick={handleConfirm}
        >
          Confirm
        </button>

        {/*
        <button
          className="CharacterContract__archetype-confirm"
          style={{ marginTop: '20px' }}
          onClick={() => {
            setStamping(false);
            setTimeout(() => setStamping(true), 100);
          }}
        >
          Test Anim
        </button>
        */}
      </div>

      <img
        src={resolveAsset('signature.png')}
        className="CharacterContract__overlay CharacterContract__signature"
        style={{ bottom: '120px', right: '60px' }}
        alt=""
      />

      {/* Hired stamp — rendered only during/after confirm animation */}
      {stamping && (
        <img
          src={resolveAsset('hired_stamp.png')}
          className="CharacterContract__overlay CharacterContract__stamp"
          style={{ bottom: '300px', right: '260px' }}
          alt=""
        />
      )}
    </div>
  );
};

// ── Page 2: Contract details ──────────────────────────────────────────────────

const ContractPage = () => {
  const { data, act } = useBackend<Data>();
  const {
    trait_title_1,
    trait_title_2,
    trait_title_3,
    trait_desc_1,
    trait_desc_2,
    trait_desc_3,
    first_name,
    last_name,
    age,
    place_of_birth,
    gender,
  } = data;

  return (
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
            <span className="CharacterContract__table-label">First name:</span>
            <Input
              fluid
              placeholder="First name"
              value={first_name ?? ''}
              onChange={(val) => act('set_first_name', { value: val })}
            />
          </div>
          <div className="CharacterContract__table-cell">
            <span className="CharacterContract__table-label">Last Name:</span>
            <Input
              fluid
              placeholder="Last name"
              value={last_name ?? ''}
              onChange={(val) => act('set_last_name', { value: val })}
            />
          </div>
        </div>

        {/* Row 2: Age / Gender radio buttons */}
        <div className="CharacterContract__table-row CharacterContract__table-row--bordered">
          <div className="CharacterContract__table-cell CharacterContract__table-cell--right-border CharacterContract__table-cell--dob">
            <span className="CharacterContract__table-label">Age:</span>
            <NumberInput
              value={age ?? 25}
              minValue={18}
              maxValue={85}
              step={1}
              onChange={(val) => act('set_age', { value: val })}
            />
          </div>
          <div className="CharacterContract__table-cell CharacterContract__table-cell--titles">
            {GENDER_OPTIONS.map((option) => (
              <label
                key={option.value}
                className="CharacterContract__radio-label"
              >
                <input
                  type="radio"
                  name="gender"
                  value={option.value}
                  checked={gender === option.value}
                  onChange={() => act('set_gender', { value: option.value })}
                />{' '}
                {option.label}
              </label>
            ))}
          </div>
        </div>

        {/* Row 3: Place of birth */}
        <div className="CharacterContract__table-cell">
          <span className="CharacterContract__table-label">
            Place of birth:
          </span>
          <Input
            fluid
            placeholder="Place of birth"
            value={place_of_birth ?? ''}
            onChange={(val) => act('set_place_of_birth', { value: val })}
          />
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
  );
};

// ── Root component ────────────────────────────────────────────────────────────

export const CharacterContract = (props) => {
  const { data } = useBackend<Data>();
  const { character_created } = data;

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
          {character_created ? <ContractPage /> : <ArchetypePage />}
        </Box>
      </Window.Content>
    </Window>
  );
};
