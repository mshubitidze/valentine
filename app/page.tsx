"use client";

import Image from "next/image";
import { useState } from "react";

const messages = [
  "არა",
  "დარწმუნებული ხარ?",
  "ნამდვილად დარწმუნებული ხარ?",
  "ნამდვილად ნამდვილად დარწმუნებული ხარ?",
  "ნატალიკო გთხოოოვ",
  "კარგად დაფიქრდი",
  "არას თუ მეტყვი მეწყინება",
  "არას თუ მეტყვი ძალიან მეწყინება",
  "არას თუ მეტყვი ძალიან ძალიან მეწყინება",
  "არას თუ მეტყვი ძალიან ძალიან ძალიან მეწყინება",
  "კაი ხო, აღარ გკითხავ...",
  "ვხუმროობ, გთხოვ, კი მითხარი",
  "არას თუ მეტყვი ძალიან ძალიან ძალიან ძალიან მეწყინება",
  "გულს მტკენ ;(",
];

export default function Home() {
  const [size, setSize] = useState(16);
  const [messageIdx, setMessageIdx] = useState(0);
  const [saidYes, setSaidYes] = useState(false);
  return (
    <main className="flex flex-col items-center justify-center min-h-screen">
      {saidYes ? (
        <>
          <Image
            className="h-[200px] w-auto"
            alt="kisses"
            src="https://media.tenor.com/gUiu1zyxfzYAAAAi/bear-kiss-bear-kisses.gif"
            width={236}
            height={233}
            priority
          />
          <h1 className="text-4xl my-4 text-center font-bold">
            კარგიი, მიხარია ❤️
          </h1>
        </>
      ) : (
        <>
          <Image
            className="h-[200px] w-auto"
            src="https://media1.tenor.com/m/NwB4QhuGUY0AAAAC/lol-amog.gif"
            alt="heart"
            priority
            width={498}
            height={396}
          />
          <h1 className="text-4xl my-4 text-center font-bold">
            იქნები ჩემი ვალენტინი?
          </h1>
          <div className="flex flex-wrap flex-col md:flex-row gap-4 items-center justify-center">
            <button
              onClick={() => {
                setSaidYes(true);
              }}
              className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
              style={{
                fontSize: `${size}px`,
              }}
            >
              კიი
            </button>
            <button
              onClick={() => {
                setMessageIdx(
                  messageIdx + 1 === messages.length ? 0 : messageIdx + 1,
                );
                setSize(size + 24);
              }}
              className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
            >
              {messages[messageIdx]}
            </button>
          </div>
        </>
      )}
    </main>
  );
}
