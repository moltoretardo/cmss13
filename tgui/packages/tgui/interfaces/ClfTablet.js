import { useBackend } from '../backend';
import { Button, Section, Flex } from '../components';
import { Window } from '../layouts';

export const ClfTablet = (_props, context) => {
  const { act, data } = useBackend(context);

  const evacstatus = data.evac_status;

  const AlertLevel = data.alert_level;

  const minimumTimeElapsed = data.worldtime > data.distresstimelock;

  const canAnnounce = data.endtime < data.worldtime;

  const canBuild = data.endtime < data.worldtime;

  const roundends = data.roundends;

  return (
    <Window width={350} height={350} theme="retro">
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
                icon="medal"
                title="Give a medal"
                content="Give a medal"
                onClick={() => act('award')}
              />
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
              <Button
                fluid={1}
                icon="circle-radiation"
                title="Call nuke airdrop"
                content="Call nuke airdrop"
                onClick={() => act('nukespawn')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="map-location-dot"
                title="Call tactical map airdrop"
                content="Call tactical map airdrop"
                onClick={() => act('tacmapspawn')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="gun"
                title="Call armory airdrop"
                content="wabababa"
                onClick={() => act('armoryspawn')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="plane-slash"
                title="Call Anti-Airstrike"
                content="Call Anti-Airstrike airdrop"
                onClick={() => act('antiairstrikespawn')}
              />
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
