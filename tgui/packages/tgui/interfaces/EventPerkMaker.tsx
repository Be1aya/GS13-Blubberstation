// THIS IS A GS13 UI FILE
import { Section, Stack, Input } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const EventPerkMaker = (props) => {
    const { act } = useBackend();
    return(
        <Window title={'Create a new perk'} width={200} height={500}>
        <Window.Content>
        <Section>
        <Stack>
            <Stack.Item>
                Name:
                <Input 
                maxLength={100}
                placeholder="Name..."
                />
            </Stack.Item>
            <Stack.Item>
                Description:
                <Input 
                placeholder="Description..."
                />
            </Stack.Item>
            <Stack.Item>
                Items:
                <Input 
                placeholder="Items..."
                />
            </Stack.Item>
            <Stack.Item>
                Ckeys:
                <Input 
                placeholder="Ckeys..."
                />
            </Stack.Item>
            <Stack.Item>
                Expiry date:
                <Input 
                placeholder="Expiry date..."
                />
            </Stack.Item>
        </Stack>
        </Section>
        </Window.Content>
        </Window>
    );
};
