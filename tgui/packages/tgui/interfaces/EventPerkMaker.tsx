// THIS IS A GS13 UI FILE
import { Section, Stack, Input, Button, TextArea, Tooltip } from 'tgui-core/components';
import { useState, } from 'react';
import type {JSX} from 'react'

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
    Name: string;
    Description: string;
    items: item[];
    ckeys: string[];
    Expiry_date: string;
};

type item = {
    name: string;
    amount: number;
};
// you don't understand how angry this clown of a language is making me
// no, it cannot accept a string as an input to a function like a normal
// fucking language
// nooooooooooooooooo you have to put everything into shitty fucking wrappers
// because fuck being normal, right? this is js, we have to be fucking clowns
// now here, come and put on your makeup.
type ckeyProp = {
    ckey: string;
};

export const EventPerkMaker = (props) => {
    const { act } = useBackend();
    const { data } = useBackend<Data>();
    const {items, ckeys} = data;
    const { Name, Description, Expiry_date } = data

    const [name, setName] = useState(Name);
    const [description, setDescription] = useState(Description);
    const [ckey, setCkey] = useState('');
    const [item, setItem] = useState('');
    const [itemAmount, setItemAmount] = useState('');
    const [expiryDate, setExpiryDate] = useState(Expiry_date);

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

    const ItemEntry = (item: item) => {
        return(
            <li key={item.name}>
                {item.name}, x{item.amount}
                {"    "}
                <Button 
                color="red"
                onClick={() => (act("remove_item", {item: item.name}))}
                >
                    Remove
                </Button>
            </li>
        );
    };

    const CkeyEntry = (ckeyProp: ckeyProp): JSX.Element => {
        const { ckey } = ckeyProp;
        return(
            <li>
                {ckey}
                {"    "}
                <Button 
                color="red"
                onClick={() => (act("remove_ckey", {ckey: ckey}))}
                >
                    Remove
                </Button>
            </li>
        );
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
                value = {Name}
                placeholder="Name of the event perk"
                onChange={setName}
                width = {15}
                />
            </Stack.Item>
            <Stack.Item>
                Description:<br/>
                <TextArea
                    fluid
                    value = {Description}
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
                    {items.map((current_item) => (
                    <ItemEntry key = {current_item.name} {...current_item} />
                    ))}
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
                disabled = {item.trim().length === 0}
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
                    {ckeys.map((current_ckey) => (
                    <CkeyEntry key = {current_ckey} ckey = {current_ckey}/>
                    ))}
                </ul>
                <Input 
                value = {ckey}
                placeholder="Ckey"
                onChange={setCkey}
                width = {15}
                />
                <Button 
                disabled = {ckey.trim().length === 0}
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
                value = {Expiry_date}
                maxLength={8}
                placeholder="DDMMYYYY"
                onChange={setExpiryDate}
                width = {15}
                />
            </Stack.Item>
            <Stack.Item>
            <Button
            onClick={submit_perk}
            disabled={name.trim().length === 0
                || expiryDate.trim().length === 0
                || ckeys.length === 0
                || items.length ===0
            }
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
