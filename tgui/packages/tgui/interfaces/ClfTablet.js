import { useBackend } from '../backend';
import { Button, Section, Flex } from '../components';
import { Window } from '../layouts';

export const ClfTablet = (_props, context) => {
  const { act, data } = useBackend(context);

  const minimumTimeElapsed = data.worldtime > data.distresstimelock;

  const canAnnounce = data.endtime < data.worldtime;

  const canBuildNuke = data.buildingNuke_endtime < data.worldtime;

  const canBuildAA = data.buildingAA_endtime < data.worldtime;

  const canBuildArmory = data.buildingArmory_endtime < data.worldtime;

  const canBuildTacmap = data.buildingTacmap_endtime < data.worldtime;

  const hasNuke = data.numberNuke > 0;

  const hasAA = data.numberAA > 0;

  const hasArmory = data.numberArmory > 0;

  const hasTacmap = data.numberTacmap > 0;

  const roundends = data.roundends;

  return (
    <Window width={350} height={350} theme="clf">
      <Window.Content scrollable>
        <Section title="CLF Command">
          <Flex height="100%" direction="column">
            <Flex.Item>
              {!canAnnounce && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Announcement on cooldown :{' '}
                  {Math.ceil((data.endtime - data.worldtime) / 10)} secs
                </Button>
              )}
              {!!canAnnounce && (
                <Button
                  fluid={1}
                  icon="bullhorn"
                  title="Make an announcement"
                  content="Make an announcement"
                  onClick={() => act('announceCLF')}
                  disabled={!canAnnounce}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="globe-africa"
                title="View tactical map"
                content="View tactical map"
                onClick={() => act('mapview')}
              />
            </Flex.Item>
          </Flex>
        </Section>
        <Section title="CLF building">
          <Flex height="100%" direction="column">
            <Flex.Item>
              {!hasNuke && canBuildNuke && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  No nuke left!
                </Button>
              )}
              {!canBuildNuke && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Building on cooldown :{' '}
                  {Math.ceil((data.buildingNuke_endtime - data.worldtime) / 10)}{' '}
                  secs
                </Button>
              )}
              {!!canBuildNuke && hasNuke && (
                <Button
                  fluid={1}
                  icon="circle-radiation"
                  title="Call nuke airdrop"
                  content="Call nuke airdrop"
                  onClick={() => act('nukespawn')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!hasTacmap && canBuildTacmap && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  No tacmap left!
                </Button>
              )}
              {!canBuildTacmap && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Building on cooldown :{' '}
                  {Math.ceil(
                    (data.buildingTacmap_endtime - data.worldtime) / 10
                  )}{' '}
                  secs
                </Button>
              )}
              {!!canBuildTacmap && hasTacmap && (
                <Button
                  fluid={1}
                  icon="map-location-dot"
                  title="Call tactical map airdrop"
                  content="Call tactical map airdrop"
                  onClick={() => act('tacmapspawn')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!hasArmory && canBuildArmory && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  No armory left!
                </Button>
              )}
              {!canBuildArmory && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Building on cooldown :{' '}
                  {Math.ceil(
                    (data.buildingArmory_endtime - data.worldtime) / 10
                  )}{' '}
                  secs
                </Button>
              )}
              {!!canBuildArmory && hasArmory && (
                <Button
                  fluid={1}
                  icon="gun"
                  title="Call armory airdrop"
                  content="Call armory airdrop"
                  onClick={() => act('armoryspawn')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!hasAA && canBuildAA && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  No anti-air left!
                </Button>
              )}
              {!canBuildAA && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Building on cooldown :{' '}
                  {Math.ceil((data.buildingAA_endtime - data.worldtime) / 10)}{' '}
                  secs
                </Button>
              )}
              {!!canBuildAA && hasAA && (
                <Button
                  fluid={1}
                  icon="plane-slash"
                  title="Call Anti-Airstrike"
                  content="Call Anti-Airstrike airdrop"
                  onClick={() => act('antiairstrikespawn')}
                />
              )}
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
