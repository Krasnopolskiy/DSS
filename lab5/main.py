import io

from PIL import Image
from sqlalchemy import Column, ForeignKey, Integer, LargeBinary, String, create_engine
from sqlalchemy.orm import Mapped, declarative_base, mapped_column, relationship, sessionmaker

Base = declarative_base()


class Good(Base):
    __tablename__ = "good"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    images: Mapped[list["GoodImage"]] = relationship("GoodImage", back_populates="good")


class GoodImage(Base):
    __tablename__ = "good_image"

    good_id: Mapped[int] = mapped_column("good", ForeignKey("good.id", ondelete="CASCADE"), primary_key=True)
    image: Mapped[bytes] = mapped_column(LargeBinary, nullable=False)
    good: Mapped["Good"] = relationship("Good", back_populates="images")


if __name__ == "__main__":
    engine = create_engine("postgresql://postgres:postgres@localhost:5432/lab5")
    Base.metadata.create_all(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    results = session.query(Good.name, GoodImage.image).join(GoodImage, Good.id == GoodImage.good_id).all()

    for name, image in results:
        print(f"Good: {name}")

        image_data = io.BytesIO(image)
        img = Image.open(image_data)
        img.show()
        input()

    session.close()
