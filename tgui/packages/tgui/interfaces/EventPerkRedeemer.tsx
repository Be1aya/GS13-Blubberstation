// THIS IS A GS13 UI FILE
import { Section, Table, Stack, Tooltip, Box, Button, } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
    available_perks: Perk[];
};

type Perk = {
    name: string;
    description: string;
    items: string;
    expiry_date: string;
    available: boolean;
};

type PerkProps = {
    perk: Perk;
};

const PerkNameAndDesc = (props: PerkProps) => {
    const {perk} = props;
    const {name, description} = perk;
    return description ? (
        <Tooltip content={description} position="bottom-start">
        <Box
            inline
            >
            <span style={{borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',}}>
            {name}
            </span>
        </Box>
        </Tooltip>
    ) : (
    <Box>{name}</Box>
    )
};

const PerkRow = (props: PerkProps) => {
    const { perk } = props;
    const { act } = useBackend<Data>();

    return (
    <Table.Row className="candystripe" >
        <Table.Cell verticalAlign="middle">
            <Stack>
                <Stack.Item>
                <PerkNameAndDesc perk = {perk} />
                </Stack.Item>
            </Stack>
        </Table.Cell>
        <Table.Cell>
            <Stack>
                <Stack.Item>
                {perk.items}
                </Stack.Item>
            </Stack>
        </Table.Cell>
        <Table.Cell>
            {perk.expiry_date}
        </Table.Cell>
        <Table.Cell>
            <Button
            disabled = {!perk.available}
            onClick={() => act("redeem_perk", {name: perk.name})}
            >
                Redeem
            </Button>
        </Table.Cell>
    </Table.Row>
    );
};

export const EventPerkRedeemer = (props) => {
    const { data } = useBackend<Data>();
    const {available_perks} = data;
    return(
    <Window title={'Redeem event perks'} width={700} height={500}>
    <Window.Content>
        <Section
        scrollable
        fill>
        <Table style={{
        borderCollapse: "separate",
        borderSpacing: "0 12px",
        }}>
            <Table.Row header>
                <Table.Cell>Name</Table.Cell>
                <Table.Cell>Items</Table.Cell>
                <Table.Cell width = "100px">Expiry date</Table.Cell>
            </Table.Row>
            {available_perks.map((current_perk) => (
                <PerkRow key = {current_perk.name} perk={current_perk} />
            ))}
        </Table>
        </Section>
    </Window.Content>
    </Window>
    );
};
