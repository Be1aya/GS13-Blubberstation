// THIS IS A GS13 UI FILE
import { Section, Table, Stack, Tooltip, Box } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
    available_perks: Perk[];
};

type Item = {
    name: string;
    amount: string;
};

type ItemProp = {
    item: Item;
};

type Perk = {
    name: string;
    description: string;
    items: string;
    expiry_date: Date;
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
            style={{borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',}}
            >
            {name}
        </Box>
        </Tooltip>
    ) : (
    <Box>{name}</Box>
    )
};

const PrintPerkItem = (props: ItemProp) => {
    const {item} = props;
    const {name} = item;

    return(
        name
    );
};

const PerkItems = (props:ItemProp) => {
    const { name, amount } = props.item;
    // const { name } = item;

    return (
        <Box>
        {name} {amount},
        </Box>
    );
};

const PerkExpiryDate = (props:PerkProps) => {
    const { expiry_date } = props.perk;

    return(
        <Box></Box>
    );
};

const PerkRow = (props: PerkProps) => {
    const { perk } = props;

    return (
    <Table.Row className="candystripe">
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
                {/* {perk.items.map(item => <PerkItems item = {item}/>)} */}
                {/* <PerkItems perk = {perk}/> */}
                </Stack.Item>
            </Stack>
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
        <Table>
            <Table.Row header>
                <Table.Cell>Name</Table.Cell>
                <Table.Cell>Items</Table.Cell>
                <Table.Cell>Expiry date</Table.Cell>
            </Table.Row>
            {available_perks.map((current_perk) => (
                <PerkRow perk={current_perk} />
            ))}
        </Table>
        </Section>
    </Window.Content>
    </Window>
    );
};
