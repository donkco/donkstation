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
  top_image?: string | null;
  bottom_image?: string | null;
  animating?: boolean;
};

const TraitColumn = ({
  title,
  description,
  highlighter,
  top_image,
  bottom_image,
  animating,
}: TraitColumnProps) => (
  <div
    className={
      'CharacterContract__trait' +
      (animating ? ' CharacterContract__trait--animating' : '')
    }
  >
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
      {top_image && (
        <img
          src={resolveAsset(top_image)}
          className="CharacterContract__trait-annotation--top"
          style={{ top: '-50px', left: '45px' }}
          alt=""
        />
      )}
      <RedactedText text={description} />
      {bottom_image && (
        <img
          src={resolveAsset(bottom_image)}
          className="CharacterContract__trait-annotation--bottom"
          style={{ marginTop: '0px', marginLeft: '0px' }}
          alt=""
        />
      )}
    </div>
  </div>
);

type ArchetypeEntry = {
  name: string;
  id: string;
  cost: number;
  affordable: boolean;
};

type ContractQuirk = {
  name: string;
  category: 'positive' | 'negative' | 'neutral';
  flavor_text: string;
  top_image?: string | null;
  bottom_image?: string | null;
};

type Data = {
  // Archetype picker
  archetypes?: ArchetypeEntry[];
  selected_archetype?: string | null;
  character_created?: boolean;
  secretary_points?: number;
  // Contract details
  contract_quirks?: ContractQuirk[];
  play_reveal_anim?: boolean;
  preview_icon?: string;
  first_name?: string;
  last_name?: string;
  age?: number;
  place_of_birth?: string;
  place_of_birth_options?: Array<{ id: string; name: string }>;
  gender?: string;
  species_name?: string;
};

const GENDER_OPTIONS = [
  { value: 'male', label: 'He/Him' },
  { value: 'female', label: 'She/Her' },
  { value: 'plural', label: 'They/Them' },
  { value: 'neuter', label: 'It/Its' },
] as const;

// ── Field dropdown (for paper-styled choiced fields) ──────────────────────────

type FieldDropdownProps = {
  value: string;
  options: Array<{ id: string; name: string }>;
  onSelect: (id: string) => void;
};

const FieldDropdown = ({ value, options, onSelect }: FieldDropdownProps) => {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  const selected = options.find((o) => o.id === value);

  return (
    <div
      className="CharacterContract__archetype-picker"
      ref={ref}
      style={{ flex: 1, minWidth: 0 }}
    >
      <div
        className={
          'CharacterContract__archetype-trigger' + (open ? ' is-open' : '')
        }
        onMouseDown={() => setOpen((o) => !o)}
        style={{ fontSize: '12px', padding: '2px 6px' }}
      >
        <span>{selected?.name ?? value}</span>
        <span className="CharacterContract__archetype-arrow">▾</span>
      </div>
      {open && (
        <div className="CharacterContract__archetype-list">
          {options.map((opt) => (
            <div
              key={opt.id}
              className={
                'CharacterContract__archetype-option' +
                (opt.id === value ? ' is-selected' : '')
              }
              onMouseDown={() => {
                onSelect(opt.id);
                setOpen(false);
              }}
            >
              {opt.name}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

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

const highlighterForCategory = (
  category: ContractQuirk['category'],
): string | undefined => {
  if (category === 'positive') return resolveAsset('green_highlighter.png');
  if (category === 'negative') return resolveAsset('red_highlighter.png');
  return undefined;
};

const ContractPage = () => {
  const { data, act } = useBackend<Data>();
  const {
    contract_quirks = [],
    play_reveal_anim,
    preview_icon,
    first_name,
    last_name,
    age,
    place_of_birth,
    place_of_birth_options = [],
    gender,
    species_name,
  } = data;

  // Fire clear_reveal_anim after the last column's animation finishes so the
  // reveal only plays once (the session the character is first created).
  useEffect(() => {
    if (!play_reveal_anim) return;
    // Last column: 2.1s delay + 0.7s duration = 2.8s total
    const timer = setTimeout(() => act('clear_reveal_anim'), 2900);
    return () => clearTimeout(timer);
  }, [play_reveal_anim]);

  return (
    <div className="CharacterContract CharacterContract__canvas">
      <Image
        width="960px"
        height="960px"
        src={resolveAsset('donkcopaper.png')}
      />

      {/* Character preview + polaroid frame + edit button — top-right corner of the paper */}
      <div
        className="CharacterContract__overlay CharacterContract__char-preview"
        style={{
          top: '90px',
          right: '-200px',
          transform: 'rotate(3deg)',
          transformOrigin: 'center top',
        }}
      >
        <div style={{ position: 'relative', display: 'inline-block' }}>
          <img
            src={resolveAsset('polaroid.png')}
            style={{ display: 'block', width: '240px' }}
            alt=""
          />
          <div
            style={{
              position: 'absolute',
              top: '18px',
              left: '50%',
              transform: 'translateX(-50%)',
            }}
          >
            {preview_icon ? (
              <img
                src={`data:image/png;base64,${preview_icon}`}
                style={{
                  width: '180px',
                  imageRendering: 'pixelated',
                  display: 'block',
                }}
                alt="Character Preview"
              />
            ) : (
              <div style={{ width: '200px', height: '200px' }} />
            )}
          </div>
        </div>
        <button
          className="CharacterContract__archetype-confirm"
          style={{
            marginTop: '8px',
            width: '80px',
            display: 'block',
            margin: '8px auto 0',
          }}
          onClick={() => act('open_preferences')}
        >
          Edit
        </button>
      </div>

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
                  type="checkbox"
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

        {/* Row 3: Place of birth / Species */}
        <div className="CharacterContract__table-row">
          <div
            className="CharacterContract__table-cell CharacterContract__table-cell--right-border"
            style={{ overflow: 'visible' }}
          >
            <span className="CharacterContract__table-label">
              Place of birth:
            </span>
            <FieldDropdown
              value={place_of_birth ?? 'earth'}
              options={place_of_birth_options}
              onSelect={(id) => act('set_place_of_birth', { value: id })}
            />
          </div>
          <div className="CharacterContract__table-cell">
            <span className="CharacterContract__table-label">Species:</span>
            {species_name ?? 'Human'}
          </div>
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
        {contract_quirks.map((quirk) => (
          <TraitColumn
            key={quirk.name}
            title={quirk.name}
            description={quirk.flavor_text}
            highlighter={highlighterForCategory(quirk.category)}
            top_image={quirk.top_image}
            bottom_image={quirk.bottom_image}
            animating={!!play_reveal_anim}
          />
        ))}
      </div>
    </div>
  );
};

// ── Root component ────────────────────────────────────────────────────────────

export const CharacterContract = (props) => {
  const { data } = useBackend<Data>();
  const { character_created } = data;

  return (
    <Window width={1450} height={1200}>
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
