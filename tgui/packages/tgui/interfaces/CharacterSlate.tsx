import { useState } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type SlateEntry = {
  index: number;
  char_slot: number;
  char_name: string;
  job: string;
};

type CharacterEntry = {
  slot: number;
  name: string;
};

type JobEntry = {
  title: string;
  department: string;
  total_positions: number;
};

type CharacterSlateData = {
  slate_slots: SlateEntry[];
  slate_characters: CharacterEntry[];
  slate_available_jobs: Record<string, JobEntry[]>;
  slate_occupied_jobs: string[];
  overflow_char_slot: number;
};

// ── Shared dropdown styles ────────────────────────────────────────────────────
const DROPDOWN_BASE: React.CSSProperties = {
  position: 'absolute',
  left: 0,
  zIndex: 200,
  background: '#150b00',
  border: '2px solid #7a3d10',
  minWidth: '200px',
  maxHeight: '200px',
  overflowY: 'auto',
  boxShadow: '0 4px 12px rgba(0,0,0,0.7)',
};

const DROPDOWN_STYLE_DOWN: React.CSSProperties = {
  ...DROPDOWN_BASE,
  top: '100%',
};

const DROPDOWN_STYLE_UPWARD: React.CSSProperties = {
  ...DROPDOWN_BASE,
  bottom: '100%',
  top: 'auto',
};

const DROPDOWN_ITEM_STYLE: React.CSSProperties = {
  padding: '5px 10px',
  cursor: 'pointer',
  color: '#e8c090',
  fontSize: '13px',
  userSelect: 'none',
  background: 'transparent',
};

const DROPDOWN_SECTION_LABEL: React.CSSProperties = {
  padding: '4px 10px 3px',
  color: '#a06030',
  fontSize: '11px',
  fontWeight: 'bold',
  letterSpacing: '0.5px',
  textTransform: 'uppercase',
  borderBottom: '1px solid #3a1a08',
};

const DROPDOWN_EMPTY: React.CSSProperties = {
  padding: '6px 10px',
  color: '#6a4020',
  fontSize: '12px',
  fontStyle: 'italic',
};

// ── ImageButton ───────────────────────────────────────────────────────────────
// Fixed 240×52px button styled with button.png.
function ImageButton(props: {
  label: string;
  disabled?: boolean;
  placeholder?: boolean;
  buttonUrl: string;
  onClick?: () => void;
}) {
  const { label, disabled, placeholder, buttonUrl, onClick } = props;
  return (
    <div
      onClick={!disabled ? onClick : undefined}
      style={{
        backgroundImage: `url(${buttonUrl})`,
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',
        imageRendering: 'pixelated',
        width: '240px',
        height: '52px',
        padding: '3px 10px',
        cursor: disabled ? 'default' : 'pointer',
        opacity: disabled ? 0.5 : 1,
        color: placeholder ? 'rgba(255,255,255,0.45)' : '#fff',
        textShadow: '1px 1px 2px rgba(0,0,0,0.95)',
        userSelect: 'none',
        whiteSpace: 'nowrap',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        display: 'flex',
        alignItems: 'center',
        fontSize: '13px',
        fontWeight: 'bold',
        letterSpacing: '0.3px',
        boxSizing: 'border-box',
      }}
    >
      {label}
    </div>
  );
}

export const CharacterSlate = () => {
  const { act, data } = useBackend<CharacterSlateData>();
  const {
    slate_slots,
    slate_characters,
    slate_available_jobs,
    slate_occupied_jobs,
    overflow_char_slot,
  } = data;

  const [dragging, setDragging] = useState<number | null>(null);
  const [dragTarget, setDragTarget] = useState<number | null>(null);
  const [overflowPickerOpen, setOverflowPickerOpen] = useState(false);

  const bgUrl = resolveAsset('job_selection_background.png');
  const selectorUrl = resolveAsset('job_selection_selector.png');
  const buttonUrl = resolveAsset('job_selection_button.png');

  // Image is displayed at 2× pixel scale: 572×764
  const CANVAS_W = 572;
  const CANVAS_H = 764;
  // Row layout inside the inner section of the background image
  const ROW_TOP = 90; // Y offset of first row (inner section starts at ~84px)
  const ROW_STRIDE = 100; // 96px height + 4px gap

  return (
    <Window width={580} height={798} title="Character Slate">
      <Window.Content
        backgroundColor="#4a2210"
        style={{ backgroundImage: 'none', padding: 0 }}
      >
        {/* Center the fixed-size canvas — same pattern as CharacterContract */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '100%',
            height: '100%',
          }}
        >
          <div
            style={{
              position: 'relative',
              width: `${CANVAS_W}px`,
              height: `${CANVAS_H}px`,
              flexShrink: 0,
              imageRendering: 'pixelated',
            }}
          >
            {/* Background image at exact pixel dimensions — never scales */}
            <img
              src={bgUrl}
              alt=""
              width={CANVAS_W}
              height={CANVAS_H}
              style={{
                display: 'block',
                imageRendering: 'pixelated',
                pointerEvents: 'none',
                position: 'absolute',
                top: 0,
                left: 0,
              }}
            />
            {/* Row layer — absolute-positioned, overflow visible for dropdowns */}
            <div
              style={{
                position: 'absolute',
                top: 0,
                left: 0,
                width: '100%',
                height: '100%',
                zIndex: 1,
                overflow: 'visible',
              }}
            >
              {slate_slots.map((entry) => (
                <div
                  key={`${entry.index}_${entry.char_slot}_${entry.job}`}
                  style={{
                    position: 'absolute',
                    top: `${ROW_TOP + (entry.index - 1) * ROW_STRIDE}px`,
                    left: '30px',
                    width: '512px',
                    height: '96px',
                  }}
                >
                  <SlateRow
                    entry={entry}
                    characters={slate_characters}
                    availableJobs={
                      slate_available_jobs[String(entry.char_slot)] ?? []
                    }
                    occupiedJobs={slate_occupied_jobs}
                    selectorUrl={selectorUrl}
                    buttonUrl={buttonUrl}
                    isDragging={dragging === entry.index}
                    isDragTarget={dragTarget === entry.index}
                    openPickerUpward={entry.index >= 4}
                    onSetCharacter={(char_slot) =>
                      act('slate_set_character', {
                        index: entry.index,
                        char_slot,
                      })
                    }
                    onSetJob={(job) =>
                      act('slate_set_job', { index: entry.index, job })
                    }
                    onClear={() =>
                      act('slate_clear_slot', { index: entry.index })
                    }
                    onDragStart={() => setDragging(entry.index)}
                    onDragOver={(e) => {
                      e.preventDefault();
                      if (dragging !== null && dragging !== entry.index) {
                        setDragTarget(entry.index);
                      }
                    }}
                    onDrop={() => {
                      if (dragging !== null && dragging !== entry.index) {
                        act('slate_reorder_slots', {
                          from: dragging,
                          to: entry.index,
                        });
                      }
                      setDragging(null);
                      setDragTarget(null);
                    }}
                    onDragEnd={() => {
                      setDragging(null);
                      setDragTarget(null);
                    }}
                  />
                </div>
              ))}

              {/* Overflow character picker — bottom-left footer panel */}
              <div
                style={{
                  position: 'absolute',
                  top: '700px',
                  left: '24px',
                }}
              >
                <div style={{ position: 'relative' }}>
                  <ImageButton
                    label={
                      overflow_char_slot > 0
                        ? (slate_characters.find(
                            (c) => c.slot === overflow_char_slot,
                          )?.name ?? `Slot ${overflow_char_slot}`)
                        : 'Pick character...'
                    }
                    placeholder={overflow_char_slot === 0}
                    buttonUrl={buttonUrl}
                    onClick={() => setOverflowPickerOpen((v) => !v)}
                  />
                  {overflowPickerOpen && (
                    <div style={DROPDOWN_STYLE_UPWARD}>
                      <div style={DROPDOWN_SECTION_LABEL}>
                        Overflow character
                      </div>
                      {slate_characters.length === 0 ? (
                        <div style={DROPDOWN_EMPTY}>
                          No characters created yet.
                        </div>
                      ) : (
                        slate_characters.map((c) => (
                          <div
                            key={c.slot}
                            style={{
                              ...DROPDOWN_ITEM_STYLE,
                              background:
                                c.slot === overflow_char_slot
                                  ? '#5a2a0a'
                                  : undefined,
                            }}
                            onMouseEnter={(e) => {
                              e.currentTarget.style.background = '#3a1800';
                            }}
                            onMouseLeave={(e) => {
                              e.currentTarget.style.background =
                                c.slot === overflow_char_slot
                                  ? '#5a2a0a'
                                  : 'transparent';
                            }}
                            onClick={() => {
                              act('slate_set_overflow', {
                                char_slot: c.slot,
                              });
                              setOverflowPickerOpen(false);
                            }}
                          >
                            {c.name}
                          </div>
                        ))
                      )}
                      {overflow_char_slot !== 0 && (
                        <div
                          style={{
                            ...DROPDOWN_ITEM_STYLE,
                            color: '#c05050',
                            borderTop: '1px solid #3a1a08',
                          }}
                          onMouseEnter={(e) => {
                            e.currentTarget.style.background = '#3a0a0a';
                          }}
                          onMouseLeave={(e) => {
                            e.currentTarget.style.background = 'transparent';
                          }}
                          onClick={() => {
                            act('slate_set_overflow', { char_slot: 0 });
                            setOverflowPickerOpen(false);
                          }}
                        >
                          Clear
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

type SlateRowProps = {
  entry: SlateEntry;
  characters: CharacterEntry[];
  availableJobs: JobEntry[];
  occupiedJobs: string[];
  selectorUrl: string;
  buttonUrl: string;
  isDragging: boolean;
  isDragTarget: boolean;
  openPickerUpward: boolean;
  onSetCharacter: (char_slot: number) => void;
  onSetJob: (job: string) => void;
  onClear: () => void;
  onDragStart: () => void;
  onDragOver: (e: React.DragEvent) => void;
  onDrop: () => void;
  onDragEnd: () => void;
};

function SlateRow(props: SlateRowProps) {
  const {
    entry,
    characters,
    availableJobs,
    occupiedJobs,
    selectorUrl,
    buttonUrl,
    isDragging,
    isDragTarget,
    openPickerUpward,
    onSetCharacter,
    onSetJob,
    onClear,
    onDragStart,
    onDragOver,
    onDrop,
    onDragEnd,
  } = props;

  const [charPickerOpen, setCharPickerOpen] = useState(false);
  const [jobPickerOpen, setJobPickerOpen] = useState(false);

  const isSlotEmpty = entry.char_slot === 0 || !entry.char_name;
  const isJobEmpty = !entry.job;

  return (
    <div
      draggable
      onDragStart={onDragStart}
      onDragOver={onDragOver}
      onDrop={onDrop}
      onDragEnd={onDragEnd}
      style={{
        backgroundImage: `url(${selectorUrl})`,
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',
        width: '100%',
        height: '100%',
        opacity: isDragging ? 0.4 : 1,
        outline: isDragTarget ? '2px solid #fff' : undefined,
        cursor: 'grab',
        display: 'flex',
        alignItems: 'flex-start',
        padding: '35px 10px',
        boxSizing: 'border-box',
        gap: '6px',
      }}
    >
      {/* Character picker */}
      <div style={{ position: 'relative', flex: 1, minWidth: 0 }}>
        <ImageButton
          label={isSlotEmpty ? 'Pick character...' : entry.char_name}
          placeholder={isSlotEmpty}
          buttonUrl={buttonUrl}
          onClick={() => {
            setCharPickerOpen((v) => !v);
            setJobPickerOpen(false);
          }}
        />
        {charPickerOpen && (
          <div
            style={{
              ...(openPickerUpward
                ? DROPDOWN_STYLE_UPWARD
                : DROPDOWN_STYLE_DOWN),
              minWidth: '240px',
            }}
          >
            <div style={DROPDOWN_SECTION_LABEL}>Select character</div>
            {characters.length === 0 ? (
              <div style={DROPDOWN_EMPTY}>No characters created yet.</div>
            ) : (
              characters.map((c) => (
                <div
                  key={c.slot}
                  style={{
                    ...DROPDOWN_ITEM_STYLE,
                    background:
                      c.slot === entry.char_slot ? '#5a2a0a' : undefined,
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.background = '#3a1800';
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.background =
                      c.slot === entry.char_slot ? '#5a2a0a' : 'transparent';
                  }}
                  onClick={() => {
                    onSetCharacter(c.slot);
                    setCharPickerOpen(false);
                  }}
                >
                  {c.name}
                </div>
              ))
            )}
            <div
              style={{
                ...DROPDOWN_ITEM_STYLE,
                color: '#c05050',
                borderTop: '1px solid #3a1a08',
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = '#3a0a0a';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = 'transparent';
              }}
              onClick={() => {
                onClear();
                setCharPickerOpen(false);
              }}
            >
              Clear slot
            </div>
          </div>
        )}
      </div>

      {/* Job picker */}
      <div style={{ position: 'relative', flex: 1, minWidth: 0 }}>
        <ImageButton
          label={isJobEmpty ? 'Pick job...' : entry.job}
          placeholder={isJobEmpty}
          disabled={isSlotEmpty}
          buttonUrl={buttonUrl}
          onClick={() => {
            setJobPickerOpen((v) => !v);
            setCharPickerOpen(false);
          }}
        />
        {jobPickerOpen && (
          <div
            style={{
              ...(openPickerUpward
                ? DROPDOWN_STYLE_UPWARD
                : DROPDOWN_STYLE_DOWN),
              minWidth: '240px',
            }}
          >
            <div style={DROPDOWN_SECTION_LABEL}>Select job</div>
            {availableJobs.length === 0 ? (
              <div style={DROPDOWN_EMPTY}>
                No jobs available for this character.
              </div>
            ) : (
              availableJobs.map((j) => {
                const inOtherSlot =
                  j.title !== entry.job && occupiedJobs.includes(j.title);
                const isSelected = j.title === entry.job;
                return (
                  <div
                    key={j.title}
                    style={{
                      ...DROPDOWN_ITEM_STYLE,
                      color: inOtherSlot
                        ? '#806040'
                        : isSelected
                          ? '#f0d080'
                          : '#e8c090',
                      background: isSelected ? '#5a2a0a' : undefined,
                    }}
                    title={
                      j.department
                        ? `${j.department} — ${j.total_positions < 0 ? '∞' : j.total_positions} positions`
                        : undefined
                    }
                    onMouseEnter={(e) => {
                      e.currentTarget.style.background = '#3a1800';
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.background = isSelected
                        ? '#5a2a0a'
                        : 'transparent';
                    }}
                    onClick={() => {
                      onSetJob(j.title);
                      setJobPickerOpen(false);
                    }}
                  >
                    {j.title}
                    {inOtherSlot && (
                      <span
                        style={{
                          marginLeft: '6px',
                          fontSize: '11px',
                          opacity: 0.6,
                        }}
                      >
                        (in use)
                      </span>
                    )}
                  </div>
                );
              })
            )}
          </div>
        )}
      </div>
    </div>
  );
}
