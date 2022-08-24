import { expect } from "chai";
import { network, ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import {
  IERC721Metadata__factory,
  IERC20Minimal__factory,
  IAlchemistV2__factory,
  IERC721Metadata,
  IERC20Minimal,
  IAlchemistV2,
  IAlchemistNFT,
} from "../typechain";
import { AlchemistJPEG } from "../typechain/AlchemistJPEG";

describe.only("Challenge to run as mainnet fork", () => {
  let impersonatedSigner: SignerWithAddress;
  let nftContract: IERC721Metadata;
  let daiContract: IERC20Minimal;
  let alchemistContract: IAlchemistV2;
  let alchemistNFTVault: AlchemistJPEG;

  /***
   * JPEG ADDRESSES
   */
  //https://opensea.io/assets/ethereum/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d/2936
  const nftId = "2936";
  //https://etherscan.io/address/0x271c7603aaf2bd8f68e8ca60f4a4f22c4920259f
  const BAYCNFTVault = "0x271c7603aaf2bd8f68e8ca60f4a4f22c4920259f";
  // https://etherscan.io/token/0x466a756E9A7401B5e2444a3fCB3c2C12FBEa0a54
  const pUSD = "0x466a756E9A7401B5e2444a3fCB3c2C12FBEa0a54";

  // https://etherscan.io/address/0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D
  const BAYC = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D";

  /**
   * ALCHEMIX ADDRESSES
   */
  // https://alchemix-finance.gitbook.io/user-docs/contracts
  const alchemistAddress = "0x5C6374a2ac4EBC38DeA0Fc1F8716e5Ea1AdD94dd";
  const yDAI = "0x5951f159eF502f0571A5D7e136a580DcadEa42Eb";
  const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";

  before(async () => {
    console.log('------- EJECUTANDO ESTO ------');
    const nftOwner = "0x271c7603AAf2BD8F68e8Ca60f4A4F22c4920259f";
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [nftOwner],
    });
    impersonatedSigner = await ethers.getSigner(nftOwner);

    nftContract = IERC721Metadata__factory.connect(BAYC, impersonatedSigner);

    daiContract = IERC20Minimal__factory.connect(DAI, impersonatedSigner);

    alchemistContract = IAlchemistV2__factory.connect(
      alchemistAddress,
      impersonatedSigner
    );

    const AlchemistJPEG = await ethers.getContractFactory("AlchemistJPEG");
    alchemistNFTVault = (await AlchemistJPEG.deploy()) as AlchemistJPEG;
    await alchemistNFTVault.deployed();
    console.log('ALCHEMIST NFT VAULT DEPLOYED');
    console.log(alchemistNFTVault.address);
  });

  describe("Do steps off chain", () => {
    it("check the Bored Ape", async () => {
      const owner = await nftContract.ownerOf(nftId);
      const address = await impersonatedSigner.getAddress();
      console.log("owner", owner);
      expect(address).eql(owner);
    });

    xit("lockNFT", async () => {
      //APPROVE NFT COLLECTION TO CONTRACT
      //await nftContract.approve(
    });

    xit("UnlockNFT", async () => {});
  });
});
