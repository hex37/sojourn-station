import { useBackend } from 'tgui/backend';
import { GameIcon } from 'tgui/components/GameIcon';
import { Window } from 'tgui/layouts';
import {
  BlockQuote,
  Box,
  Button,
  Icon,
  LabeledList,
  Modal,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

interface OwnerData {
  name: string;
  dept: string;
}

interface ErrorData {
  message: string;
  isError: boolean;
}

interface VendingProductData extends ErrorData {
  name: string;
  desc: string;
  price: number;
}

interface ProductData {
  key: number;
  name: string;
  icon: string;
  price: number;
  color?: null;
  amount: number;
}

interface VendingData {
  name: string;
  panel: boolean;
  isCustom: string;
  ownerData?: OwnerData;
  isManaging: boolean;
  managingData: ErrorData;
  isVending: boolean;
  vendingData: VendingProductData;
  products?: ProductData[];
  markup?: number;
  speaker?: string;
  advertisement?: string;
}

const managing = (managingData: ErrorData) => {
  const { act } = useBackend<VendingData>();

  return (
    <>
      <Stack.Item>
        {managingData.message.length > 0 && (
          <NoticeBox
            style={{
              overflow: 'hidden',
              wordBreak: 'break-all',
            }}
          >
            {managingData.message}
          </NoticeBox>
        )}
      </Stack.Item>
      <Stack.Item>
        <Stack justify="space-between" textAlign="center">
          <Stack.Item grow>
            <Button
              fluid
              ellipsis
              icon="building"
              onClick={() => act('setdepartment')}
            >
              Organization
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              ellipsis
              icon="id-card"
              onClick={() => act('setaccount')}
            >
              Account
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid ellipsis icon="tags" onClick={() => act('markup')}>
              Markup
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
};

const custom = (props) => {
  const { act, data } = useBackend<VendingData>();
  const { ownerData } = data;

  return (
    <Section title={data.isManaging ? 'Managment' : 'Commercial Info'}>
      <Stack fill vertical>
        <Stack>
          <Stack.Item align="center">
            <Icon name="toolbox" size={3} mx={1} />
          </Stack.Item>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Owner">
                {ownerData?.name || 'Unknown'}
              </LabeledList.Item>
              <LabeledList.Item label="Department">
                {ownerData?.dept || 'Not Specified'}
              </LabeledList.Item>
              <LabeledList.Item label="Murkup">
                {(data?.markup && data?.markup > 0 && (
                  <Box>{data.markup}</Box>
                )) ||
                  'None'}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
        {(data.isManaging && managing(data.managingData)) || null}
      </Stack>
    </Section>
  );
};

const product = (product: ProductData) => {
  const { act, config, data } = useBackend<VendingData>();

  return (
    <Stack.Item>
      <Stack fill>
        <Stack.Item grow>
          {/*
          // @ts-expect-error: Spurious error due to bad type in upstream Button component */}
          <Button
            fluid
            ellipsis
            onClick={() => act('vend', { key: product.key })}
          >
            <Stack fill align="center">
              {!config.window.toaster && (
                <Stack.Item>
                  <GameIcon html={product.icon} />
                </Stack.Item>
              )}
              <Stack.Item grow={4} textAlign="left" className="Vending--text">
                {product.name}
              </Stack.Item>
              <Stack.Item grow textAlign="right" className="Vending--text">
                {product.amount}
                <Icon name="box" pl="0.6em" />
              </Stack.Item>
              {(product.price > 0 && (
                <Stack.Item grow textAlign="right" className="Vending--text">
                  {product.price}
                  <Icon name="money-bill" pl="0.6em" />
                </Stack.Item>
              )) ||
                null}
            </Stack>
          </Button>
        </Stack.Item>
        {(data.isManaging && (
          <>
            <Stack.Item>
              <Button
                icon="tag"
                tooltip="Change Price"
                color="yellow"
                className="Vending--icon"
                verticalAlignContent="middle"
                onClick={() => act('setprice', { key: product.key })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="eject"
                tooltip="Remove"
                color="red"
                className="Vending--icon"
                verticalAlignContent="middle"
                onClick={() => act('remove', { key: product.key })}
              />
            </Stack.Item>
          </>
        )) ||
          null}
      </Stack>
    </Stack.Item>
  );
};

const pay = (vendingProduct: VendingProductData) => {
  const { act } = useBackend<VendingData>();

  return (
    <Modal className="Vending--modal">
      <Stack fill vertical justify="space-between">
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Name">
              {capitalize(vendingProduct.name)}
            </LabeledList.Item>
            <LabeledList.Item label="Description">
              {vendingProduct.desc}
            </LabeledList.Item>
            <LabeledList.Item label="Price">
              {vendingProduct.price}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <NoticeBox color={vendingProduct.isError ? 'red' : ''}>
            {vendingProduct.message}
          </NoticeBox>
        </Stack.Item>
        <Stack.Item>
          <Button
            fluid
            icon="ban"
            color="red"
            content="Cancel"
            className="Vending--cancel"
            verticalAlignContent="middle"
            onClick={() => act('cancelpurchase')}
          />
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

export const Vending = (props) => {
  const { act, data } = useBackend<VendingData>();

  return (
    <Window width={450} height={600} title={`Vending Machine - ${data.name}`}>
      <Window.Content>
        <Stack fill vertical>
          {(data.isCustom && <Stack.Item>{custom(data)}</Stack.Item>) || null}
          {(data.panel && (
            <Stack.Item>
              <Button
                fluid
                bold
                my={1}
                py={1}
                icon={data.speaker ? 'comment' : 'comment-slash'}
                content={`Speaker ${data.speaker ? 'Enabled' : 'Disabled'}`}
                textAlign="center"
                color={data.speaker ? 'green' : 'red'}
                onClick={() => act('togglevoice')}
              />
            </Stack.Item>
          )) ||
            null}
          {(data.advertisement && data.advertisement.length > 0 && (
            <Stack.Item>
              <Section>
                <BlockQuote>{data.advertisement}</BlockQuote>
              </Section>
            </Stack.Item>
          )) ||
            null}
          <Stack.Item grow>
            <Section scrollable fill title="Products">
              <Stack fill vertical>
                {data.products &&
                  data.products.map((value, i) => product(value))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
      {(data.isVending && pay(data.vendingData)) || null}
    </Window>
  );
};
