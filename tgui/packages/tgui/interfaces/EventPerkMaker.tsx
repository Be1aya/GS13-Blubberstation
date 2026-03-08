// THIS IS A GS13 UI FILE
import { Section, Stack, Input, Button, TextArea, Tooltip } from 'tgui-core/components';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
    items: String[];
    ckeys: String[];
};

type NewPerkData = {
    name: string;
    description: string;
    items: string;
    ckeys: string;
    expiry_date: string;
};

export const EventPerkMaker = (props) => {
    const { act } = useBackend<NewPerkData>();
    const { data } = useBackend<Data>();
    const {items, ckeys} = data;

    const [name, setName] = useState('');
    const [description, setDescription] = useState('');
    const [ckey, setCkey] = useState('');
    const [item, setItem] = useState('');
    const [itemAmount, setItemAmount] = useState('');
    const [expiryDate, setExpiryDate] = useState('');

    const submit_perk = () => {
        act("create_perk", {
            name: name,
            description: description,
            expiry_date: expiryDate
        });
        setName("");
        setDescription("");
        setItem("");
        setItemAmount("");
        setCkey("");
        setItem("");
        setExpiryDate("");
    };

    const submit_item = () => {
        act("add_item", {item: item, item_amount: itemAmount})
        setItem("");
        setItemAmount("");
    };

    const submit_ckey = () => {
        act("add_ckey", {ckey: ckey})
        setCkey("");
    };

    return(
        <Window title={'Create a new perk'} width={300} height={500}>
        <Window.Content scrollable>
        <Section>
        <Stack vertical fill>
            <Stack.Item>
                Name:<br/>
                <Input 
                maxLength={100}
                value = {name}
                placeholder="Name of the event perk"
                onChange={setName}
                width = {15}
                />
            </Stack.Item>
            <Stack.Item>
                Description:<br/>
                <TextArea
                    fluid
                    value = {description}
                    placeholder="Description of the event perk"
                    onChange={setDescription}
                    height = {10}
                />
            </Stack.Item>
            <Stack.Item>
                <Tooltip content = {
                    "Input the path to an item (for example, \
                    \"/obj/item/screwdriver\") in the first box, and then \
                    the amount of said item in the second box."
                }>
                <span style={{borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',}}>
                Items:
                </span>
                </Tooltip>
                <br/>
                <ul>
                    {items.map((current_item) => (<li>{current_item}</li>))}
                </ul>
                <Input 
                value = {item}
                placeholder="Item path"
                onChange={setItem}
                width = {15}
                />
                <Input 
                value = {itemAmount}
                placeholder="Amount"
                onChange={setItemAmount}
                width = {4}
                />
                <Button
                disabled = {item.trim().length == 0 || itemAmount.trim().length == 0}
                // onClick={() => (act("add_item", {item: item, item_amount: itemAmount}))}
                onClick={submit_item}
                >
                    Add
                </Button>
            </Stack.Item>
            <Stack.Item>
                <Tooltip content = {
                    "Input a ckey of a single player, and then press the add \
                    button. You can also input their username, and it will \
                    auto-convert it to a proper ckey."
                }>
                <span style={{borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',}}>
                Ckeys:
                </span>
                </Tooltip>
                <br/>
                <ul>
                    {ckeys.map((current_ckey) => (<li>{current_ckey}</li>))}
                </ul>
                <Input 
                value = {ckey}
                placeholder="Ckey"
                onChange={setCkey}
                width = {15}
                />
                <Button 
                disabled = {ckey.trim().length == 0}
                // onClick={() => act("add_ckey", {ckey: ckey})}
                onClick={submit_ckey}
                >
                    Add
                </Button>
            </Stack.Item>
            <Stack.Item>
                <Tooltip content = {
                    "The date on which the perk stops being \
                    redeemable, in DDMMYYYY format."
                    }>
                <span style={{borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',}}>
                Expiry date:
                </span>
                </Tooltip>
                <br/>
                <Input 
                value = {expiryDate}
                maxLength={8}
                placeholder="DDMMYYYY"
                onChange={setExpiryDate}
                width = {15}
                />
            </Stack.Item>
            <Stack.Item>
            <Button
            onClick={submit_perk}
            >
                Submit
            </Button>
            </Stack.Item>
        </Stack>
        </Section>
        </Window.Content>
        </Window>
    );
};
