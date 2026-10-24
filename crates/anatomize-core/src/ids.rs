//! 强类型 ID。用 newtype 而不是裸 `u16`，避免把 PartId 传给要 JointId 的地方。

use serde::{Deserialize, Serialize};
use std::fmt;

macro_rules! id_type {
    ($name:ident) => {
        #[derive(
            Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Serialize, Deserialize,
        )]
        #[serde(transparent)]
        pub struct $name(pub u16);

        impl $name {
            pub const NONE: Self = Self(u16::MAX);

            pub fn index(self) -> usize {
                self.0 as usize
            }
        }

        impl fmt::Display for $name {
            fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
                write!(f, "{}({})", stringify!($name), self.0)
            }
        }
    };
}

id_type!(PartId);
id_type!(JointId);
id_type!(OrganId);
id_type!(VesselId);
id_type!(NerveId);
id_type!(RegionId);
